terraform {
  backend "s3" {
    bucket = "terraform-remote-states-bucket"
    key    = "elk-stack/terraform.tfstate"
  }
}
