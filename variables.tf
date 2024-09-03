variable "name" {
  type = string
}

variable "root_volume_delete" {
  type    = bool
  default = true
}

variable "root_volume_encrypted" {
  type    = bool
  default = true
}

variable "root_volume_type" {
  type    = string
  default = "gp3"
}

variable "root_volume_size" {
  type    = number
  default = 0
}

variable "instance_type" {
  type    = string
  default = "m7a.xlarge"
}

variable "instance_termination_disable" {
  type    = bool
  default = false
}

variable "subnet_id" {
  type = string
}

variable "ssh_key_name" {
  type    = string
  default = null
}

variable "iam_profile_name" {
  type = string
}

variable "enclave_enabled" {
  type    = bool
  default = false
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = []
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "ami_id" {
  type    = string
  default = null
  validation {
    condition     = var.ami_id == null || can(regex("ami-[a-f0-9]{17}", var.ami_id))
    error_message = "Must be a valid AMI ID."
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "user_data_replace_on_change" {
  type    = bool
  default = false
}

variable "extra_volumes" {
  type = list(object({
    device_name    = string
    name           = optional(string, null)
    encrypted      = optional(bool, true)
    snapshot_id    = optional(string, null)
    final_snapshot = optional(bool, false)
    type           = optional(string, "gp3")
    size           = optional(number, 50)
    tags           = optional(map(string), {})
    uid            = optional(number, null)
    gid            = optional(number, null)
    mount_path     = optional(string, null)
  }))

  default = []
}

variable "app_username" {
  type    = string
  default = null
  validation {
    condition     = var.app_username == null || can(regex("^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\\$)$", var.app_username))
    error_message = "Must be a valid Linux username."
  }
}

variable "app_uid" {
  type    = number
  default = 2000
}

variable "app_gid" {
  type    = number
  default = 2000
}

variable "app_is_sudoer" {
  type    = bool
  default = false
}
