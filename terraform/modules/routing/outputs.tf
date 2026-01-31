output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_ids" {
  value = aws_nat_gateway.natgw[*].id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private.id
}
