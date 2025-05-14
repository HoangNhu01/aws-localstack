output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "aws_lb_target_group_arn" {
  value = aws_lb_target_group.web_tg.arn
}
