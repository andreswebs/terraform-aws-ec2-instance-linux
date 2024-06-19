# terraform-aws-ec2-instance-linux

A standalone Ubuntu (latest) EC2 instance.

[//]: # (BEGIN_TF_DOCS)


## Usage

Example:

```hcl
module "ec2_base" {
  source         = "github.com/andreswebs/terraform-aws-ec2-base"
  vpc_id         = var.vpc_id
  cidr_whitelist = var.cidr_whitelist
  name           = "k3s"

  allow_web_traffic = true

  extra_whitelisted_ingress_rules = [
    {
      from_port = "6443"
      to_port   = "6443"
    }
  ]

}

module "ec2_instance" {
  source                 = "github.com/andreswebs/terraform-aws-ec2-instance-linux"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [module.ec2_base.security_group.id]
  ssh_key_name           = module.ec2_base.key_pair.key_name
  iam_profile_name       = module.ec2_base.instance_profile.name
  name                   = "k3s"
}
```



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | n/a | `string` | `null` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | n/a | `bool` | `true` | no |
| <a name="input_enclave_enabled"></a> [enclave\_enabled](#input\_enclave\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_extra_volumes"></a> [extra\_volumes](#input\_extra\_volumes) | n/a | <pre>list(object({<br>    device_name    = string<br>    name           = optional(string, null)<br>    encrypted      = optional(bool, true)<br>    kms_key_id     = optional(string, null)<br>    snapshot_id    = optional(string, null)<br>    type           = optional(string, "gp3")<br>    size           = optional(number, 50)<br>    final_snapshot = optional(bool, false)<br>    tags           = optional(map(string), {})<br>  }))</pre> | `[]` | no |
| <a name="input_iam_profile_name"></a> [iam\_profile\_name](#input\_iam\_profile\_name) | n/a | `string` | n/a | yes |
| <a name="input_instance_termination_disable"></a> [instance\_termination\_disable](#input\_instance\_termination\_disable) | n/a | `bool` | `false` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | n/a | `string` | `"m6a.xlarge"` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | n/a | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | n/a | `string` | `null` | no |
| <a name="input_user_data_base64"></a> [user\_data\_base64](#input\_user\_data\_base64) | n/a | `string` | `null` | no |
| <a name="input_user_data_replace_on_change"></a> [user\_data\_replace\_on\_change](#input\_user\_data\_replace\_on\_change) | n/a | `bool` | `false` | no |
| <a name="input_volume_delete"></a> [volume\_delete](#input\_volume\_delete) | n/a | `bool` | `true` | no |
| <a name="input_volume_encrypted"></a> [volume\_encrypted](#input\_volume\_encrypted) | n/a | `bool` | `true` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | n/a | `number` | `50` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | n/a | `list(string)` | `[]` | no |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ubuntu_22_04_latest"></a> [ubuntu\_22\_04\_latest](#module\_ubuntu\_22\_04\_latest) | andreswebs/ami-ubuntu/aws | 2.0.0 |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_volume) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_volume_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/volume_attachment) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance) | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

[//]: # (END_TF_DOCS)

## Authors

**Andre Silva** - [@andreswebs](https://github.com/andreswebs)

## License

This project is licensed under the [Unlicense](UNLICENSE.md).
