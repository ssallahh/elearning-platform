variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = contains(["us-east-1", "us-west-2", "eu-west-1"], var.aws_region)
    error_message = "Invalid AWS region. Must be one of: us-east-1, us-west-2, eu-west-1."
  }
}

variable "environment" {
  description = "Deployment environment (production, staging, development)"
  type        = string
  default     = "development"

  validation {
    condition     = contains(["production", "staging", "development"], var.environment)
    error_message = "Environment must be one of: production, staging, development."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Must be a valid CIDR block format."
  }
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_username) >= 3 && length(var.db_username) <= 16
    error_message = "DB username must be between 3 and 16 characters."
  }
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 12
    error_message = "DB password must be at least 12 characters long."
  }
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"

  validation {
    condition     = contains(["db.t3.micro", "db.t3.small", "db.t3.medium"], var.db_instance_class)
    error_message = "Invalid DB instance class."
  }
}

variable "allowed_ips" {
  description = "List of IP addresses allowed to access resources"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for ip in var.allowed_ips : can(cidrhost(ip, 0))])
    error_message = "All values must be valid IP addresses or CIDR blocks."
  }
}