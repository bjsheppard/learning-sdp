/************************/
/**SSH from Jumpbox SG***/
/************************/
resource "aws_security_group" "ssh_sg" {
  name        = "ssh_sg"
  description = "SG which allows inbound ssh access"
  vpc_id      = var.vpc-id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name"          = "ssh_sg"
      "ingress_rules" = "0.0.0.0/0:22"
      "egress_rules"  = "-"
    },
    local.base_tags,
  )
}

/***************/
/***Jenkins SG**/
/***************/
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Main sg used for jenkins servers"
  vpc_id      = var.vpc-id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ingress {
  #   from_port   = 8080
  #   to_port     = 8080
  #   protocol    = "tcp"
  #   security_groups = [aws_security_group.mel_lambda_vpc_resource_access.id]
  # }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name"          = "jenkins_sg"
      "ingress_rules" = "${var.vpc-cidr}:8080"
      "egress_rules"  = "0.0.0.0/0:0"
    },
    local.base_tags,
  )
}

/***************/
/***DNS SG**/
/***************/
# resource "aws_security_group" "dns_sg" {
#   name        = "dns_sg"
#   description = "Main sg used for dns servers"
#   vpc_id      = var.vpc-id
#   ingress {
#     from_port   = 53
#     to_port     = 53
#     protocol    = "tcp"
#     cidr_blocks = [var.vpc-cidr]
#   }
#   ingress {
#     from_port   = 53
#     to_port     = 53
#     protocol    = "udp"
#     cidr_blocks = [var.vpc-cidr]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   #TODO -- need to update base tags once find a different way to do dev base tags
#   tags = merge(
#     {
#       "Name"          = "dns_sg"
#       "ingress_rules" = "${var.vpc-cidr}:53"
#       "egress_rules"  = "0.0.0.0/0:0"
#     },
#     local.base_tags,
#   )
# }
