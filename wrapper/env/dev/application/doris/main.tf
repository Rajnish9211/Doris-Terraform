module "doris_ec2" {
  source = "../../../../../modules/ec2"

  ec2_instances      = local.ec2_instances
  extra_volumes      = local.extra_volumes
  vpc_id             = var.vpc_id
  security_groups    = var.security_groups
  route_table_ids    = var.route_table_ids
  firewall_eni_id    = var.firewall_eni_id
  security_group_ports = var.security_group_ports
}