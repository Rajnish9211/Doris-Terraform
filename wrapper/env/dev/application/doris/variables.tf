variable "ami" {}
variable "key_name" {}

variable "fe_subnet" {}
variable "be_subnet" {}

variable "vpc_id" {}
variable "route_table_ids" {}
variable "firewall_eni_id" {}

variable "security_groups" {
  type = list(string)
}

variable "security_group_ports" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    name_regex  = string
  }))
}