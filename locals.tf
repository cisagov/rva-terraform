locals {
  # This is a goofy but necessary way to determine if
  # terraform.workspace contains the substring "prod"
  production_workspace = replace(terraform.workspace, "prod", "") != terraform.workspace

  # Pretty obvious what these are
  tcp_and_udp = [
    "tcp",
    "udp",
  ]
  ingress_and_egress = [
    "ingress",
    "egress",
  ]

  # domain names to use for internal DNS
  rva_private_domain = "rva"

  # zones to use for public DNS
  rva_public_zone = "cyber.dhs.gov"

  # subdomains to use in the public_zone.
  # to create records directly in the public_zone set to ""
  # otherwise it must end in a period
  rva_public_subdomain = "rva.ncats."
}
