provider "aws" {
  region  = "ap-southeast-1"
  profile = "datton.nashtech"
}

terraform {
  required_version = "~> 1.3.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-boostrap-nashtech-devops"
    key            = "network.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-network-ws-boostrap-nashtech-devops"
    profile        = "datton.nashtech"
    encrypt        = true
    kms_key_id     = "0649bddf-d19b-4709-a411-2f073472785c"
  }
}
