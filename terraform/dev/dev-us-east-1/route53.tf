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

# new rosa.bot dns

resource "aws_route53_zone" "rosa_root" {
  name = "rosa.bot"
}

# delegate api subdomain to the root zone
resource "aws_route53_record" "delegate_ns_rosa_api" {
  zone_id = "${aws_route53_zone.rosa_root.id}"
  name    = "${aws_route53_zone.rosa_api.name}"
  type    = "NS"
  ttl     = "300"

  records = [
    "${aws_route53_zone.rosa_api.name_servers.0}",
    "${aws_route53_zone.rosa_api.name_servers.1}",
    "${aws_route53_zone.rosa_api.name_servers.2}",
    "${aws_route53_zone.rosa_api.name_servers.3}",
  ]
}

# delegate app subdomain to the root zone
resource "aws_route53_record" "delegate_ns_rosa_app" {
  zone_id = "${aws_route53_zone.rosa_root.id}"
  name    = "${aws_route53_zone.rosa_app.name}"
  type    = "NS"
  ttl     = "300"

  records = [
    "${aws_route53_zone.rosa_app.name_servers.0}",
    "${aws_route53_zone.rosa_app.name_servers.1}",
    "${aws_route53_zone.rosa_app.name_servers.2}",
    "${aws_route53_zone.rosa_app.name_servers.3}",
  ]
}

# delegate app subdomain to the root zone
resource "aws_route53_record" "delegate_ns_rosa_www" {
  zone_id = "${aws_route53_zone.rosa_root.id}"
  name    = "${aws_route53_zone.rosa_www.name}"
  type    = "NS"
  ttl     = "300"

  records = [
    "${aws_route53_zone.rosa_www.name_servers.0}",
    "${aws_route53_zone.rosa_www.name_servers.1}",
    "${aws_route53_zone.rosa_www.name_servers.2}",
    "${aws_route53_zone.rosa_www.name_servers.3}",
  ]
}

resource "aws_route53_zone" "rosa_api" {
  name = "${var.apigateway_subdomain}.rosa.bot"
}

resource "aws_route53_record" "rosa_api" {
  zone_id = "${aws_route53_zone.rosa_api.id}"
  name    = "${aws_api_gateway_domain_name.forgotpw_api.domain_name}"
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
