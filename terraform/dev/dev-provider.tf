# Manual Prerequisites:
#
# gcp forgotpw-dev project created
# gcs forgotpw-dev-tfstate bucket created

# Provide GCP Credentials to Terraform:
#
# gcloud auto application-default login
# export GOOGLE_APPLICATION_CREDENTIALS=~/.config/gcloud/application_default_credentials.json

provider "google" {
  # https://github.com/terraform-providers/terraform-provider-google/releases
  version = "~> 1.16.0"
  project = "${var.project}"
  region  = "us-central1"
}

variable "environment" {
  default = "dev"
}

variable "project" {
  default = "forgotpw-dev"
}
