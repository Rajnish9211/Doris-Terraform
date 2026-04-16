locals {

  common_tags = {
    env     = "dev"
    project = "doris"
  }

  ec2_instances = {

    frontend-1 = {
      ami_id          = var.ami_id
      instance_type   = "t3.large"
      subnet_id       = var.frontend_private_subnet_id
      security_groups = ["FE-SG"]
      public_ip       = false
      key_name        = var.ssh_key_name

      volume_size           = 50
      volume_type           = "gp3"
      throughput            = 125
      encrypted_volume      = true
      delete_on_termination = true

      enable_eip             = false
      termination_protection = true

      tags = merge(local.common_tags, {
        role = "frontend"
        tier = "web"
      })
    }

    frontend-2 = {
      ami_id          = var.ami_id
      instance_type   = "t3.large"
      subnet_id       = var.frontend_private_subnet_id
      security_groups = ["FE-SG"]
      public_ip       = false
      key_name        = var.ssh_key_name

      volume_size           = 50
      volume_type           = "gp3"
      throughput            = 125
      encrypted_volume      = true
      delete_on_termination = true

      enable_eip             = false
      termination_protection = true

      tags = merge(local.common_tags, {
        role = "frontend"
        tier = "web"
      })
    }

    frontend-3 = {
      ami_id          = var.ami_id
      instance_type   = "t3.large"
      subnet_id       = var.frontend_private_subnet_id
      security_groups = ["FE-SG"]
      public_ip       = false
      key_name        = var.ssh_key_name

      volume_size           = 50
      volume_type           = "gp3"
      throughput            = 125
      encrypted_volume      = true
      delete_on_termination = true

      enable_eip             = false
      termination_protection = true

      tags = merge(local.common_tags, {
        role = "frontend"
        tier = "web"
      })
    }

    backend-1 = {
      ami_id          = var.ami_id
      instance_type   = "t3.xlarge"
      subnet_id       = var.backend_private_subnet_id
      security_groups = ["be-sg"]
      public_ip       = false
      key_name        = var.ssh_key_name

      volume_size           = 100
      volume_type           = "gp3"
      throughput            = 125
      encrypted_volume      = true
      delete_on_termination = true

      enable_eip             = false
      termination_protection = true

      tags = merge(local.common_tags, {
        role = "backend"
        tier = "app"
      })
    }

    backend-2 = {
      ami_id          = var.ami_id
      instance_type   = "t3.xlarge"
      subnet_id       = var.backend_private_subnet_id
      security_groups = ["be-sg"]
      public_ip       = false
      key_name        = var.ssh_key_name

      volume_size           = 100
      volume_type           = "gp3"
      throughput            = 125
      encrypted_volume      = true
      delete_on_termination = true

      enable_eip             = false
      termination_protection = true

      tags = merge(local.common_tags, {
        role = "backend"
        tier = "app"
      })
    }

    backend-3 = {
      ami_id          = var.ami_id
      instance_type   = "t3.xlarge"
      subnet_id       = var.backend_private_subnet_id
      security_groups = ["be-sg"]
      public_ip       = false
      key_name        = var.ssh_key_name

      volume_size           = 100
      volume_type           = "gp3"
      throughput            = 125
      encrypted_volume      = true
      delete_on_termination = true

      enable_eip             = false
      termination_protection = true

      tags = merge(local.common_tags, {
        role = "backend"
        tier = "app"
      })
    }
  }

  extra_volumes = {
    backend-1 = [
      { device_name = "/dev/sdf", size = 50 },
      { device_name = "/dev/sdg", size = 50 },
      { device_name = "/dev/sdh", size = 50 }
    ]

    backend-2 = [
      { device_name = "/dev/sdf", size = 50 },
      { device_name = "/dev/sdg", size = 50 },
      { device_name = "/dev/sdh", size = 50 }
    ]

    backend-3 = [
      { device_name = "/dev/sdf", size = 50 },
      { device_name = "/dev/sdg", size = 50 },
      { device_name = "/dev/sdh", size = 50 }
    ]
  }
}
