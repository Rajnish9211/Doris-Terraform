ec2_enabled = true

ami_id       = "ami-0a1b0c508e1fa9fce"  # Ubuntu 22.04 in ap-south-1
ssh_key_name = "doris"

frontend_private_subnet_id = "subnet-088148e90fe17306a"
backend_private_subnet_id  = "subnet-0c16a05cb6e94254b"

vpc_id = "vpc-0d15d65b05ac9ace0"

security_group_names = ["FE-SG", "be-sg"]

security_group_ingress_rules = {
  fe_ports = {
    sg_name    = "FE-SG"
    from_port  = 9030
    to_port    = 9030
    protocol   = "tcp"
  }

  be_ports = {
    sg_name    = "be-sg"
    from_port  = 9050
    to_port    = 9050
    protocol   = "tcp"
  }
}

security_group_egress_rules = {
  allow_all_outbound_backend = {
    sg_name     = "be-sg"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
