# output "s3_bucket_name" {
#   value = module.s3.bucket_name
# }

# output "s3_bucket_arn" {
#   value = module.s3.bucket_arn
# }

# output "ec2_instance_public_ip" {
#   value = module.ec2.public_ip
# }

# output "ec2_instance_arn" {
#   value = module.ec2.arn
# }

# output "vpc_azs" {
#   value = module.vpc.available_azs
# }

output "associated_subnets" {
  value = module.gateway.associated_subnets
}

output "public_subnet_route_table" {
  value = module.gateway.public_subnet_route_table
}

output "associated_subnets_private" {
  value = module.nat.associated_subnets
}

output "nat_gateway_public_subnet_id" {
  value = module.nat.nat_gateway_subnet_id
}
