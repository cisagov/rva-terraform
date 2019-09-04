# Allow ingress from guacamole instance via ssh
# For: DevOps ssh access from guacamole instance to kali ops instance
resource "aws_security_group_rule" "kali_ops_ingress_from_guacamole_via_ssh" {
  security_group_id = aws_security_group.rva_kali_ops.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.guacamole.private_ip}/32"]
  from_port         = 22
  to_port           = 22
}

# Allow ingress from guacamole instance via VNC
# For: RVA team VNC access from guacamole instance to kali ops instance
resource "aws_security_group_rule" "kali_ops_ingress_from_guacamole_via_vnc" {
  security_group_id = aws_security_group.rva_kali_ops.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["${aws_instance.guacamole.private_ip}/32"]
  from_port         = 5901
  to_port           = 5901
}

# Allow ingress from anywhere via HTTP
# For: RVA target http callbacks to kali server
resource "aws_security_group_rule" "kali_ops_ingress_from_anywhere_via_http" {
  security_group_id = aws_security_group.rva_kali_ops.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
}

# Allow ingress from anywhere via HTTPS
# For: RVA target https callbacks to kali server
resource "aws_security_group_rule" "kali_ops_ingress_from_anywhere_via_https" {
  security_group_id = aws_security_group.rva_kali_ops.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
}

# Allow ingress from anywhere via ephemeral ports below 5901 (1024-5900)
# We do not want to allow everyone to hit VNC on port 5901
resource "aws_security_group_rule" "kali_ops_ingress_from_anywhere_via_ports_1024_thru_5900" {
  security_group_id = aws_security_group.rva_kali_ops.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 1024
  to_port           = 5900
}

# Allow ingress from anywhere via ephemeral ports above 5901 (5902-65535)
# We do not want to allow everyone to hit VNC on port 5901
resource "aws_security_group_rule" "kali_ops_ingress_from_anywhere_ports_5902_thru_65535" {
  security_group_id = aws_security_group.rva_kali_ops.id
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 5902
  to_port           = 65535
}

# Allow egress to anywhere via ephmeral ports
# For: DevOps ssh access from guacamole instance to kali ops instance and
#      RVA team VNC access from guacamole instance to kali ops instance and
#      RVA target callback communication
resource "aws_security_group_rule" "kali_ops_egress_to_anywhere_via_ephemeral_ports" {
  security_group_id = aws_security_group.rva_kali_ops.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 1024
  to_port           = 65535
}

# Allow egress to anywhere via HTTPS
resource "aws_security_group_rule" "kali_ops_egress_to_anywhere_via_https" {
  security_group_id = aws_security_group.rva_kali_ops.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
}

# TODO REMOVE
# Allow egress from anywhere via HTTP
# For: updating kali image test
resource "aws_security_group_rule" "kali_ops_egress_from_anywhere_via_http" {
  security_group_id = aws_security_group.rva_kali_ops.id
  type              = "egress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
}
