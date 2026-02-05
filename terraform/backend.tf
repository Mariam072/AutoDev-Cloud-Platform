terraform {
  required_version = ">=1.5.0"
  backend "s3" {
    bucket = "terraform-state-mariam1"
    key    = "global/s3/terraform.tfstate"
    region = "eu-west-1"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.0"
    }
  }
}