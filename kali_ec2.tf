# The kali AMI
data "aws_ami" "kali" {
  filter {
    name = "name"
    values = [
      "kali-hvm-*-x86_64-ebs",
    ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners      = [data.aws_caller_identity.current.account_id] # This is us
  most_recent = true
}

# The kali EC2 instance
resource "aws_instance" "kali" {
  ami               = data.aws_ami.kali.id
  instance_type     = "t2.medium"
  availability_zone = "${var.aws_region}${var.aws_availability_zone}"
  subnet_id         = aws_subnet.rva_private.id
  # TODO: Eventually get rid of public IP address for this instance
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 25
    delete_on_termination = true
  }

  vpc_security_group_ids = [
    aws_security_group.rva_kali_ops.id,
  ]

  tags        = merge(var.tags, map("Name", "Kali"))
  volume_tags = merge(var.tags, map("Name", "Kali"))
}

# The Elastic IP for the kali instance
resource "aws_eip" "kali" {
  vpc  = true
  tags = merge(var.tags, map("Name", "Kali EIP"))
}

# The EIP association for the kali instance
resource "aws_eip_association" "kali" {
  instance_id   = aws_instance.kali.id
  allocation_id = aws_eip.kali.id
}
# Note that the EBS volume contains production data, so we use the
# prevent_destroy lifecycle element to disallow the destruction of it
# via terraform.
resource "aws_ebs_volume" "kali_data" {
  availability_zone = "${var.aws_region}${var.aws_availability_zone}"
  type              = "gp2"
  size              = 20
  encrypted         = true

  tags = merge(var.tags, map("Name", "Kali Data"))

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_volume_attachment" "kali_data_attachment" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.kali_data.id
  instance_id = aws_instance.kali.id

  # Terraform attempts to destroy the volume attachment before it attempts to
  # destroy the EC2 instance it is attached to.  EC2 does not like that and it
  # results in the failed destruction of the volume attachment.  To get around
  # this, we explicitly terminate the instance via the AWS CLI in a destroy
  # provisioner; this gracefully shuts down the instance and allows
  # terraform to successfully destroy the volume attachment.
  #
  # NOTE: These provisioners work well when destroying the entire terraform
  # environment, but do not currently (terraform 0.12.6) work as intended
  # when the instance is being replaced (i.e. destroyed and recreated by a
  # single 'terraform apply' command).  In that case, it's best to manually
  # destroy the instance (via the AWS console or CLI) and then run the
  # 'terraform apply' to re-create it.
  provisioner "local-exec" {
    when       = destroy
    command    = "aws --region=${var.aws_region} ec2 terminate-instances --instance-ids ${aws_instance.kali.id}"
    on_failure = continue
  }

  # Wait until instance is terminated before continuing on
  provisioner "local-exec" {
    when    = destroy
    command = "aws --region=${var.aws_region} ec2 wait instance-terminated --instance-ids ${aws_instance.kali.id}"
  }

  skip_destroy = true
  depends_on   = [aws_ebs_volume.kali_data]
}
