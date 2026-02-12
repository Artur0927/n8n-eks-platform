# Project Configuration

variable "project_name" {
  description = "Name of the project, used for resource naming and tagging"
  type        = string
  default     = "k8s-platform"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# AWS Configuration

variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones_count" {
  description = "Number of availability zones to use (min 2 for HA)"
  type        = number
  default     = 2

  validation {
    condition     = var.availability_zones_count >= 2
    error_message = "Must use at least 2 availability zones for high availability."
  }
}

# Network Configuration

variable "vpc_cidr" {
  description = "CIDR block for VPC (provides 65,536 IP addresses)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
}

# NAT Configuration

variable "nat_instance_type" {
  description = "EC2 instance type for NAT instance (t3.micro is cost-effective)"
  type        = string
  default     = "t3.micro"
}

variable "enable_nat_instance_monitoring" {
  description = "Enable detailed CloudWatch monitoring for NAT instance"
  type        = bool
  default     = false
}

# Tags

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Owner     = "DevOps Team"
  }
}
