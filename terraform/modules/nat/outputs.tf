output "nat_gateway_subnet_id" {
  value = [for nat in aws_nat_gateway.nat : nat.subnet_id]
}

output "associated_subnets" {
  value = [for assoc in aws_route_table_association.private : assoc.subnet_id]
}
