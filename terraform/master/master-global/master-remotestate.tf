terraform {
  backend "s3" {
    bucket         = "forgotpw-tfstate-master"
    region         = "us-east-1"
    profile        = "fpwmaster-terraform"
    dynamodb_table = "tfstate_master"
    key            = "infrastructure-global/terraform.tfstate"
  }
}
