variable "aws_region" {
  description = "The AWS region to deploy into (e.g. us-east-1)."
  default     = "us-west-1"
}

variable "aws_availability_zone" {
  description = "The AWS availability zone to deploy into (e.g. a, b, c, etc.)."
  default     = "a"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all AWS resources created"
  default     = {}
}

# This should be overridden by a production.tfvars file,
# most likely stored outside of version control
variable "trusted_ingress_networks_ipv4" {
  type        = list(string)
  description = "IPv4 CIDR blocks from which to allow ingress to the desktop gateway"
  default     = ["0.0.0.0/0"]
}

variable "trusted_ingress_networks_ipv6" {
  type        = list(string)
  description = "IPv6 CIDR blocks from which to allow ingress to the desktop gateway"
  default     = ["::/0"]
}

variable "create_rva_flow_logs" {
  type        = bool
  description = "Whether or not to create flow logs for the RVA VPC."
  default     = false
}
