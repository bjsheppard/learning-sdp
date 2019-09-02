/********************************/
/**Set the region for resources**/
/********************************/
provider "aws" {
  region = local.region
}

variable "vpc" {
  default = "mvpc"
}

variable "Environment" {
  default = "manage"
}

/********************************/
/*Set the VPC used by resources**/
/********************************/
variable "vpc-id" {
  description = "ID of the VPC"
  #TODO
  default     = "vpc-0fd86d95ada70ca39"
}

#TODO
variable "vpc-cidr" {
  default = "10.248.100.0/22"
}

/************************************/
/*Set the Subnets used by resources**/
/************************************/
variable "manage_subnet_AZ1" {
  description = "Subnet to be used for manage AZ1"
  #TODO
  default     = "subnet-0e3a8804650b53a39"
}

variable "manage_subnet_AZ2" {
  description = "Subnet to be used for manage AZ2"
  #TODO
  default     = "subnet-0c60e6bbddaa237ee"
}

/********************************************/
/**Set the Availability Zones for resources**/
/********************************************/
variable "availability_zones" {
  #TODO
  default = ["us-east-1a", "us-east-1b"]
}

variable "manage_AZ1" {
  description = "Availability Zone for all manage resources"
  #TODO
  default     = "us-east-1a"
}

variable "manage_AZ2" {
  description = "Availability Zone for all manage resources"
  #TODO
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
    #TODO  
    data.terraform_remote_state.global_state.outputs.base_tags_out
  )
}
