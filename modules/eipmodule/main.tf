resource "aws_eip" "this" {
  instance = var.instance_id
  domain = "vpc"
  
}

output "public_ip" {
  value = aws_eip.this.public_ip
}

output "domain" {
  value = aws_eip.this.public_dns
}