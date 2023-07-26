variable "project" {}

variable "environment" {}

variable "owner" {}

variable "default_db_password" {
    type      = string
    sensitive = true
    
    validation {
        condition = var.default_db_password == "" || length(var.default_db_password) < 8 || length(regex("[!/:@[~^]", var.default_db_password)) > 0
        error_message = "You are setting a very weak password. Please make it better"
    }
}

variable "another_db_password" {
    type      = string
    sensitive = true
    
    validation {
        condition = var.another_db_password == "" || length(var.another_db_password) < 8 || length(regex("[!/:@[~^]", var.another_db_password)) > 0
        error_message = "You are setting a very weak password. Please make it better"
    }
}