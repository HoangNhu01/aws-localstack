provider "aws" {
  region                      = var.region # Region mặc định khi dùng LocalStack
  access_key                  = "test"     # Khóa truy cập giả lập (LocalStack bỏ qua xác thực thật)
  secret_key                  = "test"     # Khóa bí mật giả lập
  skip_credentials_validation = true       # Bỏ qua kiểm tra khóa AWS thật
  skip_metadata_api_check     = true       # Bỏ qua gọi AWS Metadata API (vốn không tồn tại trên LocalStack)
  skip_requesting_account_id  = true       # <--- Thêm dòng này để ngăn Terraform cố lấy AWS account ID
  s3_use_path_style           = true       # Quan trọng: Bắt buộc dùng path-style URL
  endpoints {
    s3  = "http://localhost:4566" # Trỏ S3 đến LocalStack thay vì AWS thật
    ec2 = "http://localhost:4566" # Trỏ EC2 đến LocalStack
    elbv2 = "http://localhost:4566"
  }
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "alb" {
  source            = "./modules/alb"
  public_subnet_ids = module.vpc.public_subnet_ids
  instance_ec2_id   = module.ec2.ec2_id
  aws_vpc_id        = module.vpc.vpc_id
}

module "ec2" {
  source        = "./modules/ec2"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    Name = "my_ec2_instance"
  }
  aws_vpc_id              = module.vpc.vpc_id
  alb_sg_id               = module.alb.alb_sg_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  aws_lb_target_group_arn = module.alb.aws_lb_target_group_arn
}

module "vpc" {
  source = "./modules/vpc"
  tags = {
    Name = "my_vpc"
  }
}

module "igw" {
  source            = "./modules/igw"
  public_subnet_ids = module.vpc.public_subnet_ids
  tags = {
    Name        = "my_gateway"
    Environment = "dev"
  }
  aws_vpc_id = module.vpc.vpc_id
}

module "nat" {
  source             = "./modules/nat"
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  aws_vpc_id         = module.vpc.vpc_id
}

# module "cloudfont" {
#   source                      = "./modules/cloudfont"
#   bucket_regional_domain_name = module.s3.bucket_regional_domain_name
# }
