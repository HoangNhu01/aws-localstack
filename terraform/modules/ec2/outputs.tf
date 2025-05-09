output "public_ip" {
  value = aws_instance.this.public_ip
}

output "arn" {
  value = aws_instance.this.arn
}