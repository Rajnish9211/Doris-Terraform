locals {
  security_group_names = var.enabled ? distinct(flatten([
    for inst in var.ec2_instances : inst.security_groups
  ])) : []

  ebs_map = var.enabled ? {
    for v in flatten([
      for inst_key, volumes in var.extra_volumes : [
        for vol in volumes : {
          instance    = inst_key
          device_name = vol.device_name
          size        = vol.size
          volume_type = lookup(vol, "volume_type", "gp3")
        }
      ]
    ]) : "${v.instance}|${v.device_name}" => v
  } : {}
}

data "aws_security_group" "sg" {
  for_each = toset(local.security_group_names)

  name   = each.value
  vpc_id = var.vpc_id
}

resource "aws_instance" "ec2" {
  for_each = var.enabled ? var.ec2_instances : {}

  ami           = each.value.ami_id
  instance_type = each.value.instance_type
  subnet_id     = each.value.subnet_id

  vpc_security_group_ids = [
    for sg_name in each.value.security_groups :
    data.aws_security_group.sg[sg_name].id
  ]

  associate_public_ip_address = each.value.public_ip
  key_name                    = each.value.key_name
  iam_instance_profile        = lookup(each.value, "iam_instance_profile", null)

  disable_api_termination = each.value.termination_protection

  root_block_device {
    volume_size           = each.value.volume_size
    volume_type           = each.value.volume_type
    throughput            = each.value.throughput
    encrypted             = each.value.encrypted_volume
    delete_on_termination = each.value.delete_on_termination
  }

  tags = merge(
    { Name = each.key },
    each.value.tags
  )
}

resource "aws_security_group_rule" "ingress_rules" {
  for_each = var.enabled ? {
    for pair in flatten([
      for rule_key, rule_value in var.security_group_ingress_rules : [
        for sg_name in var.security_group_names : {
          rule_name = rule_key
          sg_id     = data.aws_security_group.sg[sg_name].id
          sg_name   = sg_name
          rule      = rule_value
        }
        if can(regex(rule_value.name_regex, sg_name))
      ]
    ]) : "${pair.rule_name}-${pair.sg_name}" => pair
  } : {}

  type              = "ingress"
  from_port         = each.value.rule.from_port
  to_port           = each.value.rule.to_port
  protocol          = each.value.rule.protocol
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = each.value.sg_id
}

resource "aws_security_group_rule" "egress_rules" {
  for_each = var.enabled ? {
    for pair in flatten([
      for rule_key, rule_value in var.security_group_egress_rules : [
        for sg_name in var.security_group_names : {
          rule_name = rule_key
          sg_id     = data.aws_security_group.sg[sg_name].id
          sg_name   = sg_name
          rule      = rule_value
        }
        if can(regex(rule_value.name_regex, sg_name))
      ]
    ]) : "${pair.rule_name}-${pair.sg_name}" => pair
  } : {}

  type              = "egress"
  from_port         = each.value.rule.from_port
  to_port           = each.value.rule.to_port
  protocol          = each.value.rule.protocol
  cidr_blocks       = each.value.rule.cidr_blocks
  security_group_id = each.value.sg_id
}

resource "aws_ebs_volume" "extra" {
  for_each = local.ebs_map

  availability_zone = aws_instance.ec2[each.value.instance].availability_zone
  size              = each.value.size
  type              = each.value.volume_type
}

resource "aws_volume_attachment" "extra_attach" {
  for_each = local.ebs_map

  device_name = each.value.device_name
  volume_id   = aws_ebs_volume.extra[each.key].id
  instance_id = aws_instance.ec2[each.value.instance].id
}
