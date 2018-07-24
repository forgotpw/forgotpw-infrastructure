resource "aws_route53_zone" "root_domain" {
  name = "forgotpw.com"
}

resource "aws_route53_record" "api" {
  zone_id = "${aws_route53_zone.root_domain.id}"
  name    = "${aws_api_gateway_domain_name.forgotpw_api.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.forgotpw_api.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.forgotpw_api.cloudfront_zone_id}"
    evaluate_target_health = true
  }
}
