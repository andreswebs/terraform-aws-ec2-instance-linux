
variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "cidr_whitelist_ipv4" {
  type    = list(string)
  default = []
}
