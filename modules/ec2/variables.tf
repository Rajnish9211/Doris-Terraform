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
}

variable "security_groups" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "route_table_ids" {
  type = list(string)
}

variable "firewall_eni_id" {
  type = string
}

variable "security_group_ports" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    name_regex  = string
  }))
}

variable "extra_volumes" {
  type = map(list(object({
    device_name = string
    size        = number
  })))
  default = {}
}