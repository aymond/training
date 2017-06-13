#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-a4f9f2c2
#
# Your subnet ID is:
#
#     subnet-9a479ed3
#
# Your security group ID is:
#
#     sg-00100979
#
# Your Identity is:
#
#     hdays-michel-elk
#

#module "example" {
#   source = "./example-module"
#   command = "echo Goodbye World"
#}

terraform {
  backend "atlas" {
    name = "aymon/training"
  }
}

variable "num_webs" {
  default = "2"
}

variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_ami" {
  default = "ami-a4f9f2c2"
}

variable "instance_type" {
  default = "t2.micro"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  ami                    = "${var.aws_ami}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "subnet-9a479ed3"
  vpc_security_group_ids = ["sg-00100979"]
  count                  = 2

  tags {
    "Identity"    = "hdays-michel-elk"
    "Environment" = "PROD"
    "Class"       = "TF-Training"
    "Name"        = "Web ${count.index+1}/${var.num_webs}"
  }
}

output "public_ip" {
  value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
  value = ["${aws_instance.web.*.public_dns}"]
}
