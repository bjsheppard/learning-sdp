variable "region" {
  #TODO
  default = "add_region_here"
}

#Used for project required tagging
variable "base_tags" {
  type = map(string)
  default = {
    managed      = "terraform"
    #TODO
    ProjectShort = "Project Abbreviation"
    ProjectName  = "Project Long Name"
  }
}

# https://www.terraform.io/docs/providers/aws/d/ami.html
# Getting latest AWS Linux 2 AMI
data "aws_ami" "aws_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }
}

locals {
  latest_amazon_linux_2 = data.aws_ami.aws_linux_2.id
}

