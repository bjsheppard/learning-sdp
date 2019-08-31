
variable "base_tags" {
  type = "map"
}
variable "vpc" {}
variable "cidr_block" {}
## TODO - needto revaluate ##
variable "subnet_size" {
  default = "2"
}
## TODO - uncomment to establish VPN resources ##
# variable "bgp_asn" {}
# variable "gateway_1_address" {}
# variable "gateway_2_address" {}
# variable "csr_1_tunnel_1_inside_cidr" {}
# variable "csr_1_tunnel_2_inside_cidr" {}
# variable "csr_2_tunnel_1_inside_cidr" {}
# variable "csr_2_tunnel_2_inside_cidr" {}
variable "custom_dhcp_options_id" {}