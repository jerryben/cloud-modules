# -------------------------
# Variables
# -------------------------
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "EC2 Key pair name"
  type        = string
}

variable "alb_subnet_ids" {
  description = "List of subnet IDs for ALB"
  type        = list(string)
}

variable "asg_subnet_ids" {
  description = "List of subnet IDs for Auto Scaling Group"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Minimum number of EC2 instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of EC2 instances"
  type        = number
  default     = 2
}

variable "instance_port" {
  description = "Port on EC2 instances to allow traffic"
  type        = number
  default     = 80
}

variable "alb_name" {
  description = "Name of the ALB"
  type        = string
  default     = "app-alb"
}
