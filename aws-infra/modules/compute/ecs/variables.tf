# variables.tf
variable "name" {}
variable "environment" {}
variable "vpc_id" {}
variable "private_subnet_ids" { type = list(string) }
variable "ami_id" {}
variable "instance_type" {}
variable "instance_count" { default = 2 }
variable "key_name" {}
variable "user_data" { default = "" }
variable "target_group_arn" {}
variable "alb_security_group_id" {}
