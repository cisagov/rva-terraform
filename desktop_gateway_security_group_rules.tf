# Allow ingress from trusted networks via ssh
# For: DevOps ssh access to guacamole instance
# TODO: Modify this access when VPN solution is implemented
resource "aws_security_group_rule" "desktop_gw_ingress_from_trusted_via_ssh" {
  security_group_id = aws_security_group.rva_desktop_gateway.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = var.trusted_ingress_networks_ipv4
  ipv6_cidr_blocks  = var.trusted_ingress_networks_ipv6
  from_port         = 22
  to_port           = 22
}

# Allow egress via ssh to the kali instance
# For: DevOps ssh access to kali instance
resource "aws_security_group_rule" "desktop_gw_egress_to_kali_via_ssh" {
  security_group_id = aws_security_group.rva_desktop_gateway.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.kali.private_ip}/32"]
  from_port         = 22
  to_port           = 22
}

# Allow ingress from trusted networks via port 8443 (nginx/guacamole web)
# For: RVA team access to guacamole web client
# TODO: Modify this access when VPN solution is implemented
resource "aws_security_group_rule" "desktop_gw_ingress_from_trusted_via_port_8443" {
  security_group_id = aws_security_group.rva_desktop_gateway.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = var.trusted_ingress_networks_ipv4
  ipv6_cidr_blocks  = var.trusted_ingress_networks_ipv6
  from_port         = 8443
  to_port           = 8443
}

# Allow egress via VNC to the kali instance
# For: RVA team VNC access to kali instance
resource "aws_security_group_rule" "desktop_gw_egress_to_kali_via_vnc" {
  security_group_id = aws_security_group.rva_desktop_gateway.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.kali.private_ip}/32"]
  from_port         = 5901
  to_port           = 5901
}

# TODO REMOVE
# Allow egress via port 80 of kali instance for update
# For: Allow egress via port 80 of kali instance for update
resource "aws_security_group_rule" "port_80_egress_for_kali_update" {
  security_group_id = aws_security_group.rva_desktop_gateway.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.kali.private_ip}/32"]
  from_port         = 80
  to_port           = 80
}

# TODO REMOPV
# Allow ingress via port 80 of kali instance for update
resource "aws_security_group_rule" "port_80_ingress_for_kali_update" {
  security_group_id = aws_security_group.rva_desktop_gateway.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.kali.private_ip}/32"]
  from_port         = 80
  to_port           = 80
}
# TODO REMOVE
# Temp rule for Kali update
resource "aws_security_group_rule" "desktop_ops_egress_to_anywhere_via_ephemeral_ports" {
  security_group_id = aws_security_group.rva_desktop_gateway.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 1024
  to_port           = 65535
}
