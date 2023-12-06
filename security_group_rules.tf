resource "aws_vpc_security_group_ingress_rule" "allow_ingress" {
  security_group_id = var.security_group_id

  # note: to/from is a RANGE and not source/dest
  cidr_ipv4   = var.source_cidr
  from_port   = var.listener_port
  ip_protocol = "tcp"
  to_port     = var.listener_port
}

resource "aws_vpc_security_group_egress_rule" "allow_egress" {
  security_group_id = var.security_group_id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = var.target_port
  ip_protocol = "tcp"
  to_port     = var.target_port
}
