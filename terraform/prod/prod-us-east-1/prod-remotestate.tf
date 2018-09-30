terraform {
  backend "s3" {
    bucket         = "forgotpw-tfstate-prod"
    region         = "us-east-1"
    profile        = "fpwprod-terraform"
    dynamodb_table = "tfstate_prod"
    key            = "infrastructure-us-east-1/terraform.tfstate"
  }
}
