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
