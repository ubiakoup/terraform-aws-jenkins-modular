provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["../../.secrets/credentials"]
  profile                  = "Mini-Project"
}
module "key_pair" {
  source   = "../modules/keypairmodule"
  key_name = "jenkins-key"
}

module "sg" {
  source  = "../modules/sgmodule"
  sg_name = "mini-prod-sg"
}

module "ec2" {
  source            = "../modules/ec2module"
  instance_type     = "t3.micro"
  key_name          = module.key_pair.key_name
  security_group_id = module.sg.sg_id
  aws_common_tag = {
    Name = "ec2-mini-pro-in"
  }

}

module "eip" {
  source      = "../modules/eipmodule"
  instance_id = module.ec2.instance_id
}

module "ebs" {
  source   = "../modules/ebsmodule"
  az       = module.ec2.availability_zone
  ebs_size = var.ebs_size
  ebs_common_tag = {
    Name = "ebs-mini-prod"
  }
}

resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = module.ebs.ebs_id
  instance_id = module.ec2.instance_id
}

resource "null_resource" "write_ip_domain" {
  provisioner "local-exec" {
    command = "echo ${module.eip.public_ip} ${module.eip.domain} > jenkins_ec2.txt"
  }
}

