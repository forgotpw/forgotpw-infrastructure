resource "aws_route53_zone" "rosa_root" {
  name = "rosa.bot"
}

# for delegations, route53 subdomain zones must be created first, then their
# NS records set here as delegations off the root

# delegate api-dev subdomain to the root zone
resource "aws_route53_record" "delegate_ns_rosa_api_dev" {
  zone_id = "${aws_route53_zone.rosa_root.id}"
  name    = "api-dev.rosa.bot"
  type    = "NS"
  ttl     = "600"

  records = [
    "ns-1096.awsdns-09.org",
    "ns-301.awsdns-37.com",
    "ns-924.awsdns-51.net",
    "ns-1766.awsdns-28.co.uk",
  ]
}

# delegate app-dev subdomain to the root zone
resource "aws_route53_record" "delegate_ns_rosa_app_dev" {
  zone_id = "${aws_route53_zone.rosa_root.id}"
  name    = "app-dev.rosa.bot"
  type    = "NS"
  ttl     = "600"

  records = [
    "ns-2027.awsdns-61.co.uk",
    "ns-285.awsdns-35.com",
    "ns-776.awsdns-33.net",
    "ns-1519.awsdns-61.org",
  ]
}

# delegate www-dev subdomain to the root zone
resource "aws_route53_record" "delegate_ns_rosa_www_dev" {
  zone_id = "${aws_route53_zone.rosa_root.id}"
  name    = "www-dev.rosa.bot"
  type    = "NS"
  ttl     = "600"

  records = [
    "ns-392.awsdns-49.com",
    "ns-1605.awsdns-08.co.uk",
    "ns-1487.awsdns-57.org",
    "ns-789.awsdns-34.net",
  ]
}

# delegate api (prod) subdomain to the root zone
resource "aws_route53_record" "delegate_ns_rosa_api_prod" {
  zone_id = "${aws_route53_zone.rosa_root.id}"
  name    = "api.rosa.bot"
  type    = "NS"
  ttl     = "600"

  records = [
    "ns-663.awsdns-18.net",
    "ns-508.awsdns-63.com",
    "ns-1715.awsdns-22.co.uk",
    "ns-1099.awsdns-09.org",
  ]
}

# delegate app (prod) subdomain to the root zone
resource "aws_route53_record" "delegate_ns_rosa_app_prod" {
  zone_id = "${aws_route53_zone.rosa_root.id}"
  name    = "app.rosa.bot"
  type    = "NS"
  ttl     = "600"

  records = [
    "ns-664.awsdns-19.net",
    "ns-1168.awsdns-18.org",
    "ns-284.awsdns-35.com",
    "ns-1561.awsdns-03.co.uk",
  ]
}

# delegate www (prod) subdomain to the root zone
resource "aws_route53_record" "delegate_ns_rosa_www_prod" {
  zone_id = "${aws_route53_zone.rosa_root.id}"
  name    = "www.rosa.bot"
  type    = "NS"
  ttl     = "600"

  records = [
    "ns-1869.awsdns-41.co.uk",
    "ns-694.awsdns-22.net",
    "ns-1106.awsdns-10.org",
    "ns-114.awsdns-14.com",
  ]
}

# apex record
resource "aws_route53_record" "apex" {
  zone_id = "${aws_route53_zone.rosa_root.id}"
  name    = "rosa.bot"
  type    = "A"

  alias {
    # these values are the tf output values from ../master-us-east-1/s3.tf
    name = "rosa.bot.s3-website-us-east-1.amazonaws.com"
    zone_id = "Z3AQBSTGFYJSTF"
    evaluate_target_health = false
  }
}
