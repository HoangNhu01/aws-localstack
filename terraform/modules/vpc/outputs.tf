output "available_azs" {
  value = data.aws_availability_zones.available.names
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}
