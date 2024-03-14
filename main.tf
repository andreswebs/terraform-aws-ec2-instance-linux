module "ubuntu_22_04_latest" {
  source  = "andreswebs/ami-ubuntu/aws"
  version = "2.0.0"
}

locals {
  ssh_key_name = var.ssh_key_name
  ami_id       = module.ubuntu_22_04_latest.ami_id
}

resource "aws_instance" "this" {
  ami                     = local.ami_id
  disable_api_termination = var.instance_termination_disable
  key_name                = var.ssh_key_name
  vpc_security_group_ids  = var.vpc_security_group_ids
  subnet_id               = var.subnet_id
  iam_instance_profile    = var.iam_profile_name
  instance_type           = var.instance_type

  associate_public_ip_address = false

  root_block_device {
    delete_on_termination = var.volume_delete
    encrypted             = var.volume_encrypted
    volume_size           = var.volume_size
  }

  enclave_options {
    enabled = var.enclave_enabled
  }

  tags = {
    Name = var.name
  }

  lifecycle {
    ignore_changes = [ami, tags]
  }

}

data "aws_instance" "this" {
  instance_id = aws_instance.this.id
}

resource "aws_eip" "this" {
  count    = var.associate_public_ip_address ? 1 : 0
  instance = aws_instance.this.id
  domain   = "vpc"
}
