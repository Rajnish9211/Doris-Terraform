module "doris_ec2" {
  source = "../../../../../modules/ec2"

  enabled                      = var.ec2_enabled
  ec2_instances                = local.ec2_instances
  extra_volumes                = local.extra_volumes
  vpc_id                       = var.vpc_id
  security_group_names         = var.security_group_names
  security_group_ingress_rules = var.security_group_ingress_rules
  security_group_egress_rules  = var.security_group_egress_rules
}
