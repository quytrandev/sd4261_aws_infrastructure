provider "aws" {
  region  = "us-west-2"
  profile = "quytran-aws-practical-devops"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    #args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
    args = [
      "--profile",
      "quytran-aws-practical-devops",
      "--region",
      "us-west-2",
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_id
    ]
  }
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
    bucket         = "quytran-practical-devops-bucket-tf"
    key            = "dev.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-boostrap-nashtech-devops"
    profile        = "quytran-aws-practical-devops"
    encrypt        = true
    kms_key_id     = "fff758c9-658d-4a49-98c4-3fabf9b7384d"
  }
}

data "terraform_remote_state" "bootstrap" {
  backend = "s3"
  config = {
    bucket  = "quytran-practical-devops-bucket-tf"
    key     = "terraform.tfstate"
    profile = "quytran-aws-practical-devops"
    region  = "us-west-2"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  workspace = "dev"

  config = {
    bucket  = "quytran-practical-devops-bucket-tf"
    key     = "network.tfstate"
    profile = "quytran-aws-practical-devops"
    region  = "us-west-2"
  }
}
