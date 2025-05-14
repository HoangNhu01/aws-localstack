output "public_subnet_route_table" {
  value = aws_route_table.public.id
}

output "associated_subnets" {
  value = [for assoc in aws_route_table_association.public : assoc.subnet_id]
}
