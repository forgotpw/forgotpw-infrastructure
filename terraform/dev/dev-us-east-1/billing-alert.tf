module "billing_alert" {
  source = "billtrust/billing-alarm/aws"

  # Will be appended to SNS topic and alarm name
  aws_env = "${var.environment}"
  # Alarm when estimated monthly charges are above this amount
  monthly_billing_threshold = "${var.monthly_billing_threshold}"
  # Currency is optional and defaults to USD
  currency = "USD"
}
