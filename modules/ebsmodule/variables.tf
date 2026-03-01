variable "ebs_size" {
    type = number
    description = "Taille du volume EBS en GB"
    default = 40
}

variable "ebs_common_tag" {
    type        = map(any)
    description = "set ebs tag"
    default = {
        Name = "ebs_mini_prod"
    }
}

variable "az" {
    type = string
    description = "Availability Zone pour attacher le volume"
}