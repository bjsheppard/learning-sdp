provider "aws" {
  region = "${local.region}"
}
terraform {
  backend "s3" {
    bucket         = "sdp-state-files"
    key            = "manage-vpc-state"
    dynamodb_table = "tf_state"
    region         = "us-east-1"
    encrypt        = true
  }
}
#TODO - update
data terraform_remote_state "global_state" {
  backend = "s3" 
  config = {
    bucket         = "sdp-state-files"
    key            = "global_state"
    dynamodb_table = "tf_state"
    region         = "us-east-1"
    encrypt        = true
  }
}
## TODO - update region
data terraform_remote_state "manage_state" {
  backend = "s3" 
  config = {
    bucket         = "sdp-state-files"
    key            = "manage_state"
    dynamodb_table = "tf_state"
    region         = "us-east-1"
    encrypt        = true
  }
}
# resource "aws_vpc_dhcp_options" "custom-dhcp-options" {
#   ## TODO - update 
#   domain_name = "domain name"
#   domain_name_servers = [
#     "custom_dns_servers"
#     ]

    ### TODO - for use later once DHCP options are set ### 
    # ntp_servers = [
    # "ip_of_NTP_server"
    # ]

    # netbios_name_servers = [
    # "ip_of_netbios_server"
    # ]

    # netbios_node_type = 2
    ####################

    # tags = "${merge(local.dev_base_tags, var.dhcp_options_tags)}"

#     tags = "${merge(
#             "${map(
#                 "Name", "${local.vpc}-dhcp-options-set"
#             )}",
#             "${local.dvpc_base_tags}"
#   )}"
# }

module "base" {
  source = "../../../modules/vpc"

  base_tags = "${local.mvpc_base_tags}"
  vpc = "${local.vpc}"
  cidr_block     = "${var.cidr_block}"
  ## TODO - uncomment to establish VPN resources ##
  # gateway_1_address = "${var.gateway_1_address}"
  # gateway_2_address = "${var.gateway_2_address}"
  # bgp_asn           = "${var.bgp_asn}"
  # csr_1_tunnel_1_inside_cidr = "${var.csr_1_tunnel_1_inside_cidr}"
  # csr_1_tunnel_2_inside_cidr = "${var.csr_1_tunnel_2_inside_cidr}"
  # csr_2_tunnel_1_inside_cidr = "${var.csr_2_tunnel_1_inside_cidr}"
  # csr_2_tunnel_2_inside_cidr = "${var.csr_2_tunnel_2_inside_cidr}"
  # custom_dhcp_options_id = "${aws_vpc_dhcp_options.custom-dhcp-options.id}"
}