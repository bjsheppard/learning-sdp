resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = "${var.base_tags}"
  # tags = "${merge(var.base_tags, map(
  #   "Name", var.vpc
  # ))}"
}
# ### Provide a VPC DHCP Option Association ###
# resource "aws_vpc_dhcp_options_association" "dns_resolver" {
# vpc_id         = "${aws_vpc.vpc.id}"
# dhcp_options_id = "${var.custom_dhcp_options_id}"
# }

resource "aws_subnet" "subnet_1a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidr_block,var.subnet_size,0)}"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = "${merge(var.base_tags, map(
    "Name", format("%s%s",var.vpc,"-subnet-1a")
  ))}"
}
resource "aws_subnet" "subnet_1b" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidr_block,var.subnet_size,1)}"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = "${merge(var.base_tags, map(
    "Name", format("%s%s",var.vpc,"-subnet-1b")
  ))}"
}
resource "aws_subnet" "subnet_1c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidr_block,var.subnet_size,2)}"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = false

  tags = "${merge(var.base_tags, map(
    "Name", format("%s%s",var.vpc,"-subnet-1c")
  ))}"
}
resource "aws_route_table" "primary" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(var.base_tags, map(
    "Name", format("%s%s",var.vpc,"-primary")
  ))}"
}
# resource "aws_route_table" "rt_1b" {
#   vpc_id = "${aws_vpc.vpc.id}"

#   tags = "${merge(var.base_tags, map(
#     "Name", format("%s%s",var.vpc,"-rt-1b")
#   ))}"
# }
# resource "aws_route_table" "rt_1c" {
#   vpc_id = "${aws_vpc.vpc.id}"

#   tags = "${merge(var.base_tags, map(
#     "Name", format("%s%s",var.vpc,"-rt-1c")
#   ))}"
# }
resource "aws_route_table_association" "rt_1a" {
  route_table_id = "${aws_route_table.primary.id}"
  subnet_id      = "${aws_subnet.subnet_1a.id}"
}
resource "aws_route_table_association" "rt_1b" {
  route_table_id = "${aws_route_table.primary.id}"
  subnet_id      = "${aws_subnet.subnet_1b.id}"
}
resource "aws_route_table_association" "rt_1c" {
  route_table_id = "${aws_route_table.primary.id}"
  subnet_id      = "${aws_subnet.subnet_1c.id}"
}
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.vpc.id}"
  service_name = "com.amazonaws.us-east-1.s3"

  route_table_ids = [
    "${aws_route_table.primary.id}"
  ]
}

# IGW for the public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_route_table.primary.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

## TODO - uncomment to establish VPN resources ##
# resource "aws_vpn_gateway" "vpn_gateway" {
#   vpc_id = "${aws_vpc.vpc.id}"

#   tags = "${merge(var.base_tags, map(
#     "Name", format("%s%s",var.vpc,"-vpn-gateway")
#   ))}"
# }
# resource "aws_customer_gateway" "gateway_1" {
#   bgp_asn    = "${var.bgp_asn}"
#   ip_address = "${var.gateway_1_address}"
#   type       = "ipsec.1"

#   tags = "${merge(var.base_tags, map(
#     "Name", format("%s%s",var.vpc,"-customer-gateway-1")
#   ))}"
# }
# resource "aws_customer_gateway" "gateway_2" {
#   bgp_asn    = "${var.bgp_asn}"
#   ip_address = "${var.gateway_2_address}"
#   type       = "ipsec.1"

#   tags = "${merge(var.base_tags, map(
#     "Name", format("%s%s",var.vpc,"-customer-gateway-2")
#   ))}"
# }
# resource "aws_vpn_connection" "vpn_connection_1" {
#   vpn_gateway_id      = "${aws_vpn_gateway.vpn_gateway.id}"
#   customer_gateway_id = "${aws_customer_gateway.gateway_1.id}"
#   type                = "ipsec.1"
#   static_routes_only  = false
#   tunnel1_inside_cidr = "${var.csr_1_tunnel_1_inside_cidr}"
#   tunnel2_inside_cidr = "${var.csr_1_tunnel_2_inside_cidr}"
# }
# resource "aws_vpn_connection" "vpn_connection_2" {
#   vpn_gateway_id      = "${aws_vpn_gateway.vpn_gateway.id}"
#   customer_gateway_id = "${aws_customer_gateway.gateway_2.id}"
#   type                = "ipsec.1"
#   static_routes_only  = false
#   tunnel1_inside_cidr = "${var.csr_2_tunnel_1_inside_cidr}"
#   tunnel2_inside_cidr = "${var.csr_2_tunnel_2_inside_cidr}"
# }
# resource "aws_vpn_gateway_route_propagation" "vgw_rt_1a" {
#   vpn_gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
#   route_table_id = "${aws_route_table.rt_1a.id}"
# }
# resource "aws_vpn_gateway_route_propagation" "vgw_rt_1b" {
#   vpn_gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
#   route_table_id = "${aws_route_table.rt_1b.id}"
# }
# resource "aws_vpn_gateway_route_propagation" "vgw_rt_1c" {
#   vpn_gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
#   route_table_id = "${aws_route_table.rt_1c.id}"
# }
# ############### ADDS IN VPC FLOW LOGS ###############
# resource "aws_flow_log" "vpc_flow_log" {
#   iam_role_arn    = "${aws_iam_role.vpc_flow_log_iam_role.arn}"
#   log_destination = "${aws_cloudwatch_log_group.vpc_flow_log_cloudwatch_log_group.arn}"
#   traffic_type    = "ALL"
#   vpc_id          = "${aws_vpc.vpc.id}"
# }

# resource "aws_cloudwatch_log_group" "vpc_flow_log_cloudwatch_log_group" {
#   name = "${var.vpc}-flow-logs"
#   retention_in_days = 365
# }

# resource "aws_iam_role" "vpc_flow_log_iam_role" {
#   name = "${var.vpc}-flow-logs-role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "vpc-flow-logs.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy" "vpc_flow_log_iam_role_policy" {
#   name = "${var.vpc}-flow-logs-role-policy"
#   role = "${aws_iam_role.vpc_flow_log_iam_role.id}"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents",
#         "logs:DescribeLogGroups",
#         "logs:DescribeLogStreams"
#       ],
#       "Effect": "Allow",
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }