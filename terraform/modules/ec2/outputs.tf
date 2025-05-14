output "public_ip" {
  value = aws_instance.this.public_ip
}

output "arn" {
  value = aws_instance.this.arn
}

output "ec2_id" {
  value = aws_instance.this.id
}

