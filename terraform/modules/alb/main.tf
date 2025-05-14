resource "aws_lb" "app_alb" {
  name               = "public-aws-alb"
  internal           = false # Xác định ALB là public hay private (có kết nối với internet bên ngoài không)
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids[*] # Bắt buộc phải để ở ít nhất 2 subnets để đẩm bảo HA
  security_groups    = [aws_security_group.alb_sg.id]

  enable_deletion_protection = false # Cho môi trường dev

}

# ALB SG - Cho phép từ Internet
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = var.aws_vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 8086 # Đây là port mà EC2 instances (backend servers) đang chạy ứng dụng
  protocol = "HTTP"
  vpc_id   = var.aws_vpc_id

  health_check {
    protocol = "HTTP" # NLB chỉ hỗ trợ health check TCP/HTTP/HTTPS
    port     = 80    # Port kiểm tra health check
  }
}



resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80" # Port mà ALB lắng nghe từ client
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

