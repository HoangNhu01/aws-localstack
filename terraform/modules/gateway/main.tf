# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = var.aws_vpc_id
  # tags = var.tags
}

# Route Table cho public subnets
resource "aws_route_table" "public" {
  vpc_id = var.aws_vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  # tags = { Name = "public-rt" }
}

# Cấu hình associate cho các public subnet
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}
