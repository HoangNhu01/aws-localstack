variable "region" {
  default = "us-east-1"
}

variable "bucket_name" {
  type = string
}

variable "ami_id" {
  default = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  type = string
}