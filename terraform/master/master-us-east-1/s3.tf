resource "aws_s3_bucket" "apex" {
    bucket = "rosa.bot"
    acl = "public-read"

    website {
        redirect_all_requests_to = "www.rosa.bot"
    }
}

# these output values will need to be used in ../master-global/route53.tf

output "website_endpoint" {
    value = "${aws_s3_bucket.apex.website_endpoint}"
}

output "hosted_zone_id" {
    value = "${aws_s3_bucket.apex.hosted_zone_id}"
}
