
module "ec2_base" {
  source              = "andreswebs/ec2-base/aws"
  version             = "0.3.0"
  vpc_id              = var.vpc_id
  cidr_whitelist_ipv4 = var.cidr_whitelist_ipv4
  name                = "example"

  allow_web_traffic = true

  extra_whitelisted_ingress_rules = [
    {
      from_port = "4321"
      to_port   = "4321"
    }
  ]

}

module "ec2_instance" {
  source                 = "../../"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [module.ec2_base.security_group.id]
  iam_profile_name       = module.ec2_base.instance_profile.name
  name                   = "example"

  app_username  = "example"
  app_is_sudoer = true

  extra_volumes = [
    {
      device_name = "/dev/sdf"
      size        = 10
      uid         = 2000
      gid         = 2000
      mount_path  = "/data"
    },
  ]
}
