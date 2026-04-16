locals {

  common_tags = {
    env = "dev"
  }

  ec2_instances = {

    # 🔹 FE
    fe-master = {
      ami_id        = var.ami
      instance_type = "t3.large"
      subnet_id     = var.fe_subnet
      security_groups = ["fe-sg"]
      public_ip     = false
      key_name      = var.key_name

      volume_size            = 50
      volume_type            = "gp3"
      throughput             = 125
      encrypted_volume       = true
      delete_on_termination  = true

      enable_eip             = false
      termination_protection = true

      tags = merge(local.common_tags, {
        role = "fe"
      })
    }

    # 🔹 BE
    be-1 = {
      ami_id        = var.ami
      instance_type = "t3.xlarge"
      subnet_id     = var.be_subnet
      security_groups = ["be-sg"]
      public_ip     = false
      key_name      = var.key_name

      volume_size            = 100
      volume_type            = "gp3"
      throughput             = 125
      encrypted_volume       = true
      delete_on_termination  = true

      enable_eip             = false
      termination_protection = true

      tags = merge(local.common_tags, {
        role = "be"
      })
    }
  }

  # 🔥 Extra disks (for BE only)
  extra_volumes = {
    "be-1" = [
      { device_name = "/dev/sdf", size = 100 },
      { device_name = "/dev/sdg", size = 50 },
      { device_name = "/dev/sdh", size = 50 }
    ]
  }
}