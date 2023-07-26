variable "aws-region" {
  description = "AWS region to launch servers."
  default     = "us-east-2"
}

variable "availability-zones" {
  type    = list(string)
  default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "public-subnet-numbers" {
  type = map(string)
}

variable "private-subnet-numbers" {
  type = map(string)
}

variable "create_private_natgw" {
  type    = bool
  default = true
}

variable "security-groups" {
  type    = any
  default = {}
}

variable "vpc-endpoint-s3-enable" {}

variable "name" {}

variable "project" {}

variable "environment" {}

variable "tags" {}

variable "vpc-cidr-block" {}
