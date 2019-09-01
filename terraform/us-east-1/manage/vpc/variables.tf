#TODO - update to corerct VPC CIDR once we have it ##
variable "cidr_block" {
    default = "cidr_block"
}
## TODO - uncomment and populate to establish VPN resources ##
# variable "gateway_1_address" {
#     default = ""
# }
# variable "gateway_2_address" {
#     default = ""
# }
# variable "csr_1_tunnel_1_inside_cidr" {
#     default = ""
# }
# variable "csr_1_tunnel_2_inside_cidr" {
#     default = ""
# }
# variable "csr_2_tunnel_1_inside_cidr" {
#     default = ""
# }
# variable "csr_2_tunnel_2_inside_cidr" {
#     default = ""
# }
# variable "bgp_asn" {
#     default = ""
# }
locals {
    #TODO
    region = "${data.terraform_remote_state.<global_state>.region}"
    vpc = "${data.terraform_remote_state.<manage_state_name>.vpc}"
    mvpc_base_tags = "${data.terraform_remote_state.<manage_state_name>.mvpc_base_tags}"
}


