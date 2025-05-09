variable "vpc_cidr" {
  default = "172.20.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  default = [
    "172.20.0.0/20",  # 172.20.0.0 – 172.20.15.255
    "172.20.16.0/20", # 172.20.16.0 – 172.20.31.255
    "172.20.32.0/20"  # 172.20.32.0 – 172.20.47.255
  ]
}

variable "private_subnets" {
  type        = list(string)
  default = [
    "172.20.48.0/20", # 172.20.48.0 – 172.20.63.255
    "172.20.64.0/20", # 172.20.64.0 – 172.20.79.255
    "172.20.80.0/20"  # 172.20.80.0 – 172.20.95.255
  ]
}

variable "isolated_subnets" {
  type        = list(string)
  default = [
    "172.20.96.0/20", # v.v...
    "172.20.112.0/20",
    "172.20.128.0/20"
  ]
}

variable "tags" {
  type    = map(string)
  default = {}
}