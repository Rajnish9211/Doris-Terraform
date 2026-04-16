variable "enabled" {
  type        = bool
  default     = true
  description = "Enable or disable this EC2 module"
}

variable "ec2_instances" {
  type = map(object({
    ami_id                 = string
    instance_type          = string
    subnet_id              = string
    security_groups        = list(string)
    public_ip              = bool
    key_name               = string
    volume_size            = number
    volume_type            = string
    throughput             = number
    encrypted_volume       = bool
    delete_on_termination  = bool
    enable_eip             = bool
    termination_protection = bool
    iam_instance_profile   = optional(string)
    tags                   = map(string)
  }))
  description = "EC2 instance configuration map"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups exist"
}

variable "security_group_names" {
  type        = list(string)
  default     = []
  description = "Existing security group names to attach to EC2 instances"
}

variable "security_group_ingress_rules" {
  type = map(object({
    from_port  = number
    to_port    = number
    protocol   = string
    name_regex = string
  }))
  default     = {}
  description = "Optional security group ingress rules"
}

variable "security_group_egress_rules" {
  type = map(object({
    from_port  = number
    to_port    = number
    protocol   = string
    cidr_blocks = optional(list(string), ["0.0.0.0/0"])
    name_regex = string
  }))
  default     = {}
  description = "Optional security group egress rules"
}

variable "extra_volumes" {
  type = map(list(object({
    device_name = string
    size        = number
    volume_type = optional(string, "gp3")
  })))
  default     = {}
  description = "Additional EBS volumes to attach to instances"
}
