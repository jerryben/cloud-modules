variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

variable "allowed_http_cidrs" {
  description = "List of CIDR blocks allowed for HTTP traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_https_cidrs" {
  description = "List of CIDR blocks allowed for HTTPS traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ecs_container_port" {
  description = "Port on which ECS containers listen"
  type        = number
}
