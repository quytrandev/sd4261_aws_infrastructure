variable "project" {}

variable "environment" {}

variable "owner" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "iam_role_default_name" {}

variable "iam_instance_profile_name" {}

variable "security_group_name" {}
