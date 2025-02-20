module "ubuntu_24_04_latest" {
  source  = "andreswebs/ami-ubuntu/aws"
  version = "3.0.0"
}

data "aws_subnet" "this" {
  id = var.subnet_id
}

data "cloudinit_config" "this" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/tpl/cloudinit.yaml.tftpl", {
      volumes       = var.extra_volumes
      app_username  = var.app_username
      app_uid       = var.app_uid
      app_gid       = var.app_gid
      app_is_sudoer = var.app_is_sudoer
    })
  }

}

locals {
  ami_id           = var.ami_id != null ? var.ami_id : module.ubuntu_24_04_latest.ami_id
  root_volume_size = var.root_volume_size == 0 ? null : var.root_volume_size
  extra_volumes    = { for volume in var.extra_volumes : volume.device_name => volume }
}

resource "aws_instance" "this" {
  ami                     = local.ami_id
  disable_api_termination = var.instance_termination_disable
  key_name                = var.ssh_key_name
  vpc_security_group_ids  = var.vpc_security_group_ids
  subnet_id               = data.aws_subnet.this.id
  iam_instance_profile    = var.iam_profile_name
  instance_type           = var.instance_type

  root_block_device {
    delete_on_termination = var.root_volume_delete
    encrypted             = var.root_volume_encrypted
    volume_type           = var.root_volume_type
    volume_size           = local.root_volume_size
    kms_key_id            = var.kms_key_id
  }

  enclave_options {
    enabled = var.enclave_enabled
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  user_data_base64            = data.cloudinit_config.this.rendered
  user_data_replace_on_change = var.user_data_replace_on_change

  tags = merge(var.tags, {
    Name = var.name
  })

  lifecycle {
    ignore_changes = [ami, tags]
  }

}

resource "aws_eip" "this" {
  count    = var.associate_public_ip_address ? 1 : 0
  instance = aws_instance.this.id
  domain   = "vpc"
}

resource "aws_ebs_volume" "this" {
  for_each = local.extra_volumes

  availability_zone = data.aws_subnet.this.availability_zone
  size              = each.value.size
  encrypted         = each.value.encrypted
  kms_key_id        = var.kms_key_id
  snapshot_id       = each.value.snapshot_id
  type              = each.value.type
  final_snapshot    = each.value.final_snapshot

  tags = merge(each.value.tags, {
    Name = each.value.name
  })
}

resource "aws_volume_attachment" "this" {
  depends_on = [aws_ebs_volume.this]
  for_each   = local.extra_volumes

  device_name = each.value.device_name
  instance_id = aws_instance.this.id
  volume_id   = aws_ebs_volume.this[each.key].id
}

data "aws_instance" "this" {
  instance_id = aws_instance.this.id
}
