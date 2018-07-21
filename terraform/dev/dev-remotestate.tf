terraform {
  backend "gcs" {
    bucket  = "forgotpw-dev-tfstate"
    prefix  = "infrastructure"
    project = "forgotpw-dev"
  }
}
