resource "aws_s3_bucket" "deploy" {
  bucket = "forgotpw-deploy-${var.environment}"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "userdata" {
  bucket = "forgotpw-userdata-${var.environment}"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
