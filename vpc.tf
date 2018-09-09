# list of AZs for the region we are working in
# https://www.terraform.io/docs/providers/aws/d/availability_zones.html
data "aws_availability_zones" "available" {
  state = "available"
}

# using locals here to provide an output for AZs
locals {
  azs = ["${split(",", length(var.vpc_azs) > 0 ? join(",", var.vpc_azs) : join(",", data.aws_availability_zones.available.names))}"]
}

module "vpc" {
  # pin module source to a specific version to avoid surprises
  # ref: https://www.terraform.io/docs/modules/sources.html#selecting-a-revision
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v1.40.0"

  name                              = "${var.vpc_name}"
  cidr                              = "${var.vpc_cidr_block}"
  # this clever split bit was found at
  # https://github.com/hashicorp/terraform/issues/12453#issuecomment-284273475
  # it gets us around the "conditional operator cannot be used with list values" errors
  azs                               = ["${split(",", length(var.vpc_azs) > 0 ? join(",", var.vpc_azs) : join(",", data.aws_availability_zones.available.names))}"]
  private_subnets                   = "${var.private_subnets}"
  public_subnets                    = "${var.public_subnets}"
  enable_dns_hostnames              = "${var.enable_dns_hostnames}"
  enable_dns_support                = "${var.enable_dns_support}"  
  enable_nat_gateway                = "${var.enable_nat_gateway}"
  single_nat_gateway                = "${var.single_nat_gateway}"
  one_nat_gateway_per_az            = "${var.one_nat_gateway_per_az}"
  # ipv6 support is very minimal
  # see https://github.com/terraform-aws-modules/terraform-aws-vpc/pull/21
  assign_generated_ipv6_cidr_block  = "${var.enable_ipv6}"

  # VPC Endpoints
  enable_s3_endpoint                = "${var.enable_s3_endpoint}"
  enable_dynamodb_endpoint          = "${var.enable_dynamodb_endpoint}"

  # VPN Gateway
  enable_vpn_gateway                = "${var.enable_vpn_gateway}"

  # enable_dhcp_options defaults to false
  enable_dhcp_options               = "${var.enable_dhcp_options}"

  # custom dhcp option set (only applied if enable_dhcp_options is true)
  dhcp_options_domain_name          = "${var.dhcp_options_domain_name}"
  dhcp_options_domain_name_servers  = "${var.dhcp_options_domain_name_servers}"
  dhcp_options_ntp_servers          = "${var.dhcp_options_ntp_servers}"

  # Tags that are added to everything we create
  tags = "${var.tags}"
}
