output "id" {
  value = data.aws_instance.this.id
}

output "public_ip" {
  value = aws_eip.this.public_ip
}
