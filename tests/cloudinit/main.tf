locals {
  cloud_config = templatefile("${path.module}/../../tpl/cloud-config.yaml.tftpl", {
    app_username  = "app"
    app_gid       = 2000
    app_uid       = 2000
    app_is_sudoer = true

    # app_home_dir = "/var/lib/app"
    app_home_dir = null

    # volumes = []
    volumes = [
      {
        device_name = "/dev/sdf"
        mount_path  = "/data"
        size        = 10
        uid         = 2000
        gid         = 2000
      },
    ]
  })
}

output "cloud_config" {
  value = local.cloud_config
}
