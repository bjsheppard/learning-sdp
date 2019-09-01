/********************************/
/**Set the region for resources**/
/********************************/
provider "aws" {
  region = local.region
}

variable "vpc" {
  default = "dvpc"
}

variable "Environment" {
  default = "Development"
}

#TODO - output the below ro dev vpc state then import#

/********************************/
/*Set the VPC used by resources**/
/********************************/
variable "vpc-id" {
  description = "ID of the VPC"
  default     = "vpc-09c6fbb1fe7e70ea6"
}

#TODO
variable "vpc-cidr" {
  default = "10.247.100.0/22"
}

/************************************/
/*Set the Subnets used by resources**/
/************************************/
variable "dev_subnet_AZ1" {
  description = "Subnet to be used for DEV AZ1"
  default     = "subnet-03a13aa7a7f1f01c5"
}

variable "dev_subnet_AZ2" {
  description = "Subnet to be used for DEV AZ2"
  default     = "subnet-0bc044559760ee35a"
}

/********************************************/
/**Set the Availability Zones for resources**/
/********************************************/
variable "availability_zones" {
  default = ["us-east-1a", "us-east1b"]
}

variable "dev_AZ1" {
  description = "Availability Zone for all DEV resources"
  default     = "us-east-1a"
}

variable "dev_AZ2" {
  description = "Availability Zone for all DEV resources"
  default     = "us-east-1b"
}

locals {
  #TODO
  region    = data.terraform_remote_state.global_state.outputs.region_out
  base_tags = merge(
    {
      "VPC"         = var.vpc
      "Environment" = var.Environment
    },
    data.terraform_remote_state.global_state.outputs.base_tags_out
  )
}
