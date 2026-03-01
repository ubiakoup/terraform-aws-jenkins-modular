resource "aws_ebs_volume" "myebs" {
  availability_zone = var.az
  size              = var.ebs_size
  type              = "gp3"
  tags              = var.ebs_common_tag

}

# Output pour récupérer l'ID du volume
output "ebs_id" {
  value = aws_ebs_volume.myebs.id
}

output "ebs_size" {
  value = aws_ebs_volume.myebs.size
}