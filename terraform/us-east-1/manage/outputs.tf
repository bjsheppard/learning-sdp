#Used for VAEC required tagging
output "region_out" {
  value = local.region
}

output "Environment_out" {
  value = var.Environment
}

output "vpc_out" {
  value = var.vpc
}

output "vpc-id_out" {
  value = var.vpc-id
}

output "vpc-cidr_out" {
  value = var.vpc-cidr
}

output "manage_subnet_1_out" {
  value = var.manage_subnet_AZ1
}

output "manage_subnet_2_out" {
  value = var.manage_subnet_AZ2
}

output "manage_AZ1_out" {
  value = var.manage_AZ1
}

output "manage_AZ2_out" {
  value = var.manage_AZ2
}

output "mvpc_base_tags_out" {
  value = local.base_tags
}

output "ssh_sg_out" {
  value = aws_security_group.ssh_sg.id
}

output "jenkins_sg_out" {
  value = aws_security_group.jenkins_sg.id
}

output "dns_sg_out" {
  value = aws_security_group.dns_sg.id
}
