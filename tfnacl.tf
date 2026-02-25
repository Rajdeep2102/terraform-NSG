provider  "aws" {
	region = "us-east-1"
}
#create the vpc
resource"aws_vpc" "custom_vpc"{
	cidr_block = "10.0.0.0/24"
	tags = {
	Name = "TF-VPC"
	}
}
#create the subnet
resource "aws_subnet" "private_subnet"{
vpc_id = aws_vpc.custom_vpc.id
cidr_block = "10.0.0.0/26"
availability_zone = "us-east-1a"
tags = {
Name = "aws-subnet"
}
}
#Network ACL
resource "aws_network_acl" "TFACL" {
vpc_id = aws_vpc.custom_vpc.id
tags = {
Name = "TFACL"
	}
}

#Allow  https
resource "aws_network_acl_rule" "inbound_https" {
  network_acl_id = aws_network_acl.TFACL.id
  rule_number    = 100
  egress         = false
  protocol       = "6"   # TCP
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}
#block HTTP
resource "aws_network_acl_rule" "deny_http" {
  network_acl_id = aws_network_acl.TFACL.id
  rule_number    = 110
  egress         = false
  protocol       = "6"
  rule_action    = "deny"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

#associate NACL with Subnet
resource "aws_network_acl_association" "subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  network_acl_id = aws_network_acl.TFACL.id
}

