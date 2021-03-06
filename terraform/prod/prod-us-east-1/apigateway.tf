resource "aws_api_gateway_rest_api" "forgotpw_api" {
  name               = "${var.apigateway_subdomain}.rosa.bot"
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

resource "aws_api_gateway_domain_name" "forgotpw_api" {
  domain_name = "${var.apigateway_subdomain}.rosa.bot"

  certificate_arn = "${aws_acm_certificate.api_rosa_bot.arn}"
}

resource "aws_api_gateway_base_path_mapping" "forgotpw_api" {
  api_id      = "${aws_api_gateway_rest_api.forgotpw_api.id}"
  stage_name  = "${aws_api_gateway_deployment.live.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.forgotpw_api.domain_name}"
}

resource "aws_api_gateway_account" "forgotpw" {
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

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = "${aws_api_gateway_rest_api.forgotpw_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.forgotpw_api.root_resource_id}"
  path_part   = "v1"
}

output "apigateway_id" {
  value = "${aws_api_gateway_rest_api.forgotpw_api.id}"
}

output "apigateway_root_resource_id" {
  value = "${aws_api_gateway_rest_api.forgotpw_api.root_resource_id}"
}

output "apigateway_v1_resource_id" {
  value = "${aws_api_gateway_resource.v1.id}"
}
