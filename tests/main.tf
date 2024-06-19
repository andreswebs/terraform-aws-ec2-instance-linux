
module "ec2_base" {
  source         = "andreswebs/ec2-base/aws"
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
  source                 = "../"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [module.ec2_base.security_group.id]
  ssh_key_name           = module.ec2_base.key_pair.key_name
  iam_profile_name       = module.ec2_base.instance_profile.name
  name                   = "k3s"

  extra_volumes = [
    {
      device_name = "/dev/sdf"
      volume_size = 100
    },
  ]
}
