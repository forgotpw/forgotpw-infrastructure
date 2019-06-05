resource "aws_route53_zone" "api" {
  name = "${var.apigateway_subdomain}.forgotpw.com"
}

resource "aws_route53_record" "api" {
  zone_id = "${aws_route53_zone.api.id}"
  name    = "${aws_api_gateway_domain_name.forgotpw_api.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.forgotpw_api.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.forgotpw_api.cloudfront_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_zone" "app" {
  name = "${var.webapp_subdomain}.forgotpw.com"
}

resource "aws_route53_zone" "www" {
  name = "${var.website_subdomain}.forgotpw.com"
}

# new rosa.bot subdomains

resource "aws_route53_zone" "rosa_api" {
  name = "${var.apigateway_subdomain}.rosa.bot"
}

resource "aws_route53_record" "rosa_api" {
  zone_id = "${aws_route53_zone.rosa_api.id}"
  name    = "${var.apigateway_subdomain}.rosa.bot"
  type    = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.forgotpw_api.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.forgotpw_api.cloudfront_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_zone" "rosa_app" {
  name = "${var.webapp_subdomain}.rosa.bot"
}

resource "aws_route53_zone" "rosa_www" {
  name = "${var.website_subdomain}.rosa.bot"
}

resource "aws_acm_certificate" "www_rosa_bot" {
  domain_name       = "${var.website_subdomain}.rosa.bot"
  validation_method = "DNS"
}

resource "aws_route53_record" "www_rosa_bot_acm_validation" {
  name    = "${aws_acm_certificate.www_rosa_bot.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.www_rosa_bot.domain_validation_options.0.resource_record_type}"
  zone_id = "${aws_route53_zone.rosa_www.zone_id}"
  records = ["${aws_acm_certificate.www_rosa_bot.domain_validation_options.0.resource_record_value}"]
  ttl     = "60"
}

resource "aws_acm_certificate_validation" "www_rosa_bot" {
  certificate_arn = "${aws_acm_certificate.www_rosa_bot.arn}"
  validation_record_fqdns = [
    "${aws_route53_record.www_rosa_bot_acm_validation.fqdn}",
  ]
}

resource "aws_acm_certificate" "api_rosa_bot" {
  domain_name       = "${var.apigateway_subdomain}.rosa.bot"
  validation_method = "DNS"
}

resource "aws_route53_record" "api_rosa_bot_acm_validation" {
  name    = "${aws_acm_certificate.api_rosa_bot.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.api_rosa_bot.domain_validation_options.0.resource_record_type}"
  zone_id = "${aws_route53_zone.rosa_api.zone_id}"
  records = ["${aws_acm_certificate.api_rosa_bot.domain_validation_options.0.resource_record_value}"]
  ttl     = "60"
}

resource "aws_acm_certificate_validation" "api_rosa_bot" {
  certificate_arn = "${aws_acm_certificate.api_rosa_bot.arn}"
  validation_record_fqdns = [
    "${aws_route53_record.api_rosa_bot_acm_validation.fqdn}",
  ]
}

resource "aws_acm_certificate" "app_rosa_bot" {
  domain_name       = "${var.webapp_subdomain}.rosa.bot"
  validation_method = "DNS"
}

resource "aws_route53_record" "app_rosa_bot_acm_validation" {
  name    = "${aws_acm_certificate.app_rosa_bot.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.app_rosa_bot.domain_validation_options.0.resource_record_type}"
  zone_id = "${aws_route53_zone.rosa_app.zone_id}"
  records = ["${aws_acm_certificate.app_rosa_bot.domain_validation_options.0.resource_record_value}"]
  ttl     = "60"
}

resource "aws_acm_certificate_validation" "app_rosa_bot" {
  certificate_arn = "${aws_acm_certificate.app_rosa_bot.arn}"
  validation_record_fqdns = [
    "${aws_route53_record.app_rosa_bot_acm_validation.fqdn}",
  ]
}
