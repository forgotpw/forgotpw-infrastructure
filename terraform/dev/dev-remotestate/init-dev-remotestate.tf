# initially create the tfstate bucket, must be run first

provider "aws" {
  region  = "us-east-1"
  profile = "fpwdev-terraform"
  version = "~> 1.28.0"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "forgotpw-tfstate-dev"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "tfstate_dev"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
