# Tạo EIP cho từng private subnets
resource "aws_eip" "nat_eip" {
  count = length(var.public_subnet_ids)
 # Không sử dụng thuộc tính 'vpc' nữa
  domain = "vpc" # Thay thế bằng 'domain' với giá trị "vpc" hoặc "standard"
  # depends_on = [aws_internet_gateway.igw]
  # tags = {
  #   Name = "nat-eip-${count.index}"
  # }
}

# Tạo NAT Gateway (đặt tại các public subnets)
resource "aws_nat_gateway" "nat" {
  count = length(var.public_subnet_ids)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]
  # tags = {
  #   Name = "nat-gw-${count.index}"
  # }
  # depends_on = [aws_internet_gateway.igw]
}

# Tạo Route Table cho private subnet
resource "aws_route_table" "private" {
  vpc_id = var.aws_vpc_id
  count = length(var.public_subnet_ids)
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  # tags = {
  #   Name = "private-rt"
  # }
}

# Gán Route Table vào các private subnet
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_ids)

  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private[count.index].id
}