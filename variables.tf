variable "name" {
  type = string
}

variable "volume_delete" {
  type    = bool
  default = true
}

variable "volume_encrypted" {
  type    = bool
  default = true
}

variable "volume_size" {
  type    = number
  default = 50
}

variable "instance_type" {
  type    = string
  default = "m6a.xlarge"
}

variable "instance_termination_disable" {
  type    = bool
  default = false
}

variable "subnet_id" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "iam_profile_name" {
  type = string
}

variable "enclave_enabled" {
  type    = bool
  default = false
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = []
}

variable "associate_public_ip_address" {
  type    = bool
  default = true
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
