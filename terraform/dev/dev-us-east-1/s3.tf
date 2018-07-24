resource "aws_s3_bucket" "terraform_state" {
  bucket = "forgotpw-deploy-${var.environment}"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
