resource "aws_api_gateway_rest_api" "forgotpw_api" {
  name               = "ForgotPW API"
  binary_media_types = ["multipart/form-data"]
}

resource "aws_api_gateway_deployment" "live" {
  rest_api_id = "${aws_api_gateway_rest_api.forgotpw_api.id}"

  stage_name = "live"

  depends_on = [
    "aws_api_gateway_integration.up",
  ]
}

resource "aws_api_gateway_method_settings" "forgotpw_api" {
  rest_api_id = "${aws_api_gateway_rest_api.forgotpw_api.id}"
  stage_name  = "live"
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }

  depends_on = ["aws_api_gateway_deployment.live"]
}

# MANUAL STEP: create the aws acm ssl certificate for:
# *.forgotpw.com, forgotpw.com
data "aws_acm_certificate" "forgotpw" {
  domain   = "*.forgotpw.com"
  statuses = ["ISSUED"]
}

resource "aws_api_gateway_domain_name" "forgotpw_api" {
  domain_name = "${var.apigateway_subdomain}.forgotpw.com"

  certificate_arn = "${data.aws_acm_certificate.forgotpw.arn}"
}

resource "aws_api_gateway_base_path_mapping" "forgotpw_api" {
  api_id      = "${aws_api_gateway_rest_api.forgotpw_api.id}"
  stage_name  = "${aws_api_gateway_deployment.live.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.forgotpw_api.domain_name}"
}

resource "aws_api_gateway_account" "arc" {
  cloudwatch_role_arn = "${aws_iam_role.apigateway.arn}"
}

resource "aws_iam_role" "apigateway" {
  name = "role-apigateway"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "apigateway_cloudwatch" {
  name = "policy-apigateway-cloudwatch"
  role = "${aws_iam_role.apigateway.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

output "apigateway_root_resource_id" {
  value = "${aws_api_gateway_rest_api.forgotpw_api.root_resource_id}"
}

output "apigateway_id" {
  value = "${aws_api_gateway_rest_api.forgotpw_api.id}"
}
