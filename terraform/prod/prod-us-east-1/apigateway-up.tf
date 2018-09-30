resource "aws_api_gateway_resource" "up" {
  rest_api_id = "${aws_api_gateway_rest_api.forgotpw_api.id}"
  parent_id   = "${aws_api_gateway_resource.v1.id}"
  path_part   = "up"
}

resource "aws_api_gateway_method" "up" {
  rest_api_id   = "${aws_api_gateway_rest_api.forgotpw_api.id}"
  resource_id   = "${aws_api_gateway_resource.up.id}"
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "up" {
  rest_api_id = "${aws_api_gateway_rest_api.forgotpw_api.id}"
  resource_id = "${aws_api_gateway_resource.up.id}"
  http_method = "${aws_api_gateway_method.up.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration" "up" {
  rest_api_id = "${aws_api_gateway_rest_api.forgotpw_api.id}"
  resource_id = "${aws_api_gateway_resource.up.id}"
  http_method = "${aws_api_gateway_method.up.http_method}"
  type        = "MOCK"

  request_templates {
    "application/json" = <<EOF
{
    "statusCode": 200
}
EOF
  }
}

resource "aws_api_gateway_integration_response" "up" {
  rest_api_id = "${aws_api_gateway_rest_api.forgotpw_api.id}"
  resource_id = "${aws_api_gateway_resource.up.id}"
  http_method = "${aws_api_gateway_method.up.http_method}"
  status_code = "${aws_api_gateway_method_response.up.status_code}"

  response_templates {
    "application/json" = <<EOF
{
    "statusCode": 200
}
EOF
  }
}
