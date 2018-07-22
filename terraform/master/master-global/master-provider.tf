provider "aws" {
  region  = "${var.aws["region"]}"
  profile = "${var.aws["profile"]}"
  version = "~> 1.28.0"
}

variable "aws" {
  default = {
    region  = "us-east-1"
    profile = "fpwmaster-terraform"
  }
}

variable "environment" {
  default = "master"
}

variable "aws_account_id" {
  default = "775893492659"
}

variable "region" {
  default = "us-east-1"
}

variable "aws-accounts" {
  type = "map"

  default = {
    "dev" = "478543871670"

    #"prod" = "tbd"
  }
}

variable "aws-account-abbrevs" {
  type = "list"

  default = [
    "dev",
  ]

  #"prod",
}
