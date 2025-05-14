resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

# Lấy 3 Availability Zones
data "aws_availability_zones" "available" {}

# Các subnet CIDR cụ thể giống ảnh (Public, Private, Isolated)
locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  # Sử dụng biến đã định nghĩa
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  isolated_subnets = var.isolated_subnets
}

# Tạo public subnet
resource "aws_subnet" "public" {
  count                   = length(local.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_subnets[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true # Tự động gán ip public cho các instances trong các subnet này
  # tags = {
  #   Name = "public-${local.azs[count.index]}"
  # }
}

# Tạo private subnet
resource "aws_subnet" "private" {
  count             = length(local.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnets[count.index]
  availability_zone = local.azs[count.index]
  # tags = {
  #   Name = "private-${local.azs[count.index]}"
  # }
}

# Tạo isolated subnet
resource "aws_subnet" "isolated" {
  count             = length(local.isolated_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.isolated_subnets[count.index]
  availability_zone = local.azs[count.index]
  # tags = {
  #   Name = "isolated-${local.azs[count.index]}"
  # }
}
