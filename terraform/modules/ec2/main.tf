resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.demo.key_name
  security_groups             = [aws_security_group.ec2_sg.name]
  associate_public_ip_address = false # Chỉ gán cho subnet công cộng
  subnet_id                   = var.private_subnet_ids[0]
  #   tags = var.tags
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from private EC2" > /var/www/html/index.html
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
}

resource "aws_key_pair" "demo" {
  key_name   = var.key_name
  public_key = file("~/.ssh/id_rsa.pub") # hoặc tự sinh key mới
}

resource "aws_eip" "example" {
  # Không sử dụng thuộc tính 'vpc' nữa
  domain = "vpc" # Thay thế bằng 'domain' với giá trị "vpc" hoặc "standard"

  #   tags = {
  #     Name = "localstack-eip"
  #   }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.example.id
}

# Tạo tường lửa cho ec2
resource "aws_security_group" "ec2_sg" {
  vpc_id = var.aws_vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Cho phếp gọi ra tất cả các địa chỉ 
  }

  ingress {
    from_port       = 8086
    to_port         = 808
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
    # cidr_blocks = ["0.0.0.0/0"] # Cho phép tất cả địa chỉ ssh vào
  }
}

resource "aws_lb_target_group_attachment" "web_attach" {
  target_group_arn = var.aws_lb_target_group_arn
  target_id        = aws_instance.this.id
}
