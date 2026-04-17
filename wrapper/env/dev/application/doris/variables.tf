variable "ec2_enabled" {
  type        = bool
  default     = true
  description = "Enable or disable the Doris EC2 deployment"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instances"
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key pair name for EC2 instances"
}

variable "frontend_private_subnet_id" {
  type        = string
  description = "Private subnet ID for frontend instances"
}

variable "backend_private_subnet_id" {
  type        = string
  description = "Private subnet ID for backend instances"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where resources are deployed"
}

variable "security_group_names" {
  type        = list(string)
  default     = []
  description = "Existing security group names for frontend and backend instances"
}

variable "security_group_ingress_rules" {
  type = map(object({
    sg_name     = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), ["0.0.0.0/0"])
  }))
  default     = {}
  description = "Ingress rules with target security group names"
}

variable "security_group_egress_rules" {
  type = map(object({
    sg_name     = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), ["0.0.0.0/0"])
  }))
  default     = {}
  description = "Egress rules with target security group names"
}
