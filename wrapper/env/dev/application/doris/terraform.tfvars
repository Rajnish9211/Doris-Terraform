ami = "ami-0ec10929233384c7f"
key_name = "doris"

fe_subnet = "subnet-088148e90fe17306a"
be_subnet = "subnet-0c16a05cb6e94254b"

vpc_id = "vpc-0d15d65b05ac9ace0"
route_table_ids = ["rtb-0953b59c2f1709a98"]
firewall_eni_id = "eni-06714481454027411"

security_groups = ["fe-sg", "be-sg"]

security_group_ports = {
  fe_ports = {
    from_port  = 9030
    to_port    = 9030
    protocol   = "tcp"
    name_regex = "fe-sg"
  }

  be_ports = {
    from_port  = 9050
    to_port    = 9050
    protocol   = "tcp"
    name_regex = "be-sg"
  }
}
