output "id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = var.associate_public_ip_address ? aws_eip.this[0].public_ip : ""
}

output "private_ip" {
  value = data.aws_instance.this.private_ip
}
