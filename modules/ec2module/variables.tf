variable "instance_type" {
  type        = string
  description = "set aws instance type"
  default     = "t3.micro"
}

variable "aws_common_tag" {
  type        = map(any)
  description = "set aws tag"
  default = {
    Name = "EC2_mini_pro_in-TF"
  }

}

variable "security_group_id" {
  type        = string
  description = "sg id"
  default = "aws_security_group.allow_http_https_ssh.id"
  }

 variable "key_name" {
  description = "The name for the key pair"
  type        = string
  default     = null
}