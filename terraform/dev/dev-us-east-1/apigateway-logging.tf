resource "aws_cloudwatch_log_group" "execution_logs" {
  # name must be in exactly the format below
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.forgotpw_api.id}/api"
  retention_in_days = 3

  # tags {
  #   SumoURL     = "${sumologic_http_source.execution_logs.url}"
  # }
}

resource "aws_cloudwatch_log_group" "access_logs" {
  name              = "API-Gateway-Access-Logs_${aws_api_gateway_rest_api.forgotpw_api.id}/api"
  retention_in_days = 3

  # tags {
  #   SumoURL     = "${sumologic_http_source.access_logs.url}"
  # }
}

# resource "aws_cloudwatch_log_subscription_filter" "execution_logs_fw_to_sumo" {
#   name            = "execution_logs_to_sumo"
#   destination_arn = "${var.cwtosumo["forwarder_arn"]}"
#   log_group_name  = "${aws_cloudwatch_log_group.execution_logs.name}"
#   filter_pattern  = ""
# }
# resource "aws_cloudwatch_log_subscription_filter" "access_logs_fw_to_sumo" {
#   name            = "access_logs_to_sumo"
#   destination_arn = "${var.cwtosumo["forwarder_arn"]}"
#   log_group_name  = "${aws_cloudwatch_log_group.access_logs.name}"
#   filter_pattern  = ""
# }
variable "logformat" {
  # available fields:
  # https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html#context-variable-reference?cmpid=docs_apigateway_console
  default = <<EOH
{
  "requestId": "$context.requestId",
  "httpMethod": "$context.httpMethod",
  "sourceIp": "$context.identity.sourceIp",
  "userAgent": "$context.identity.userAgent",
  "path": "$context.path",
  "requestTimeEpoch": "$context.requestTimeEpoch",
  "responseLength": "$context.responseLength",
  "responseLatency": "$context.responseLatency",
  "status", "$context.status",
  "caller": "$context.identity.caller",
  "errorMessage": "$context.error.message"
}
EOH
}

# example sumologic query for above format:
# _source="prod arc apigateway access logs" | parse "*" as jsonobj
# | json field=jsonobj "message", "timestamp" as message, timestamp
# | json field=message "httpMethod", "sourceIp", "path", "userAgent", "requestTimeEpoch" , "responseLength", "responseLatency", "status", "errorMessage"
# | fields -jsonobj | fields -message
output "setup_accesslogging_command" {
  value = <<EOH
!!!!!!!!!
ATTENTION
=========
Run this command to enable access logging for the apigateway.
# set the cloudwatch log group destination
aws apigateway update-stage \
  --rest-api-id ${aws_api_gateway_rest_api.forgotpw_api.id} \
  --stage-name ${aws_api_gateway_deployment.live.stage_name} \
  --patch-operations '[ { "op" : "replace", "path" : "/accessLogSettings/destinationArn", "value" : "${replace(aws_cloudwatch_log_group.access_logs.arn, ":*", "")}" } ]' \
  --profile ${var.aws["profile"]} \
  --region ${var.aws["region"]}
# set the log format
aws apigateway update-stage \
  --rest-api-id ${aws_api_gateway_rest_api.forgotpw_api.id} \
  --stage-name ${aws_api_gateway_deployment.live.stage_name} \
  --patch-operations '[ { "op" : "replace", "path" : "/accessLogSettings/format", "value" : "${replace(replace(var.logformat, "\"", "\\\""), "\n", "")}" } ]' \
  --profile ${var.aws["profile"]} \
  --region ${var.aws["region"]}
EOH
}
