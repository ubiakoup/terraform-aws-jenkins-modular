data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "myec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  user_data = file("${path.module}/user_data.sh")
  user_data_replace_on_change = true
  tags          = var.aws_common_tag
  root_block_device {
    delete_on_termination = true
  }

}

output "instance_id" {
  value = aws_instance.myec2.id
}

output "availability_zone" {
  value = aws_instance.myec2.availability_zone
}

output "public_ip" {
  value = aws_instance.myec2.public_ip
  
}

output "public_dns" {
  value = aws_instance.myec2.public_dns
}