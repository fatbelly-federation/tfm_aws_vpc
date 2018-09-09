################################# VARIABLES ######################################

# We try to avoid defining too many defaults here
# if a variable doesn't have a value defined (e.g. in the calling terraform.tfvars)
# terragrunt will then prompt for a value
# this helps to ensure that everything is properly defined in calling .tfvars

variable "vpc_name" { 
  description = "Name for the VPC"
  # use something at least unique. Adding descriptive is useful
  # e.g. jelly-stable-vpc  or jelly-dev-vpc
  # your VPCs will not be as long-lived as you expect.
}

variable "vpc_cidr_block" {
  description = "CIDR Block for the VPC."
  # This CIDR encompasses both the public & private subnets
  # /21 aka 255.255.248.0 netmask is a good choice
}

variable "vpc_azs" {
  description = "A list of Availability Zones to use"
  type        = "list"
  default     = []
  # default to an empty list, so we can default to letting terraform discover
  # the available AZs for the region we are building in
}

variable "public_subnets" { 
  type = "list"
  description = "list of CIDRs that will used for our public subnets"
  # instances in public subnets *WILL* receive a random public ip address
  # instances in public subnets *ARE* accessible from the internet
  # splitting a Class C(/24) into /26 networks is a good choice
}

variable "private_subnets" { 
  type = "list"
  description = "list of CIDRs that will used for our private subnets"
  # instances in private subnets do *NOT* receive a public IP address
  # A Class C(/24) network for each subnet is a good choice
}

variable "trusted_subnets" { 
  type = "list" 
  default = []
  description = "list of CIDRs that we trust. e.g. remote network connected via vpn"
}

variable "region" {
  description = "The AWS region we are going to perform our actions in"
}

variable "enable_nat_gateway"   {
  description = "Add a nat gateway(s) to the vpc"
  # ref: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
  # pricing: https://aws.amazon.com/vpc/pricing/
  # enabling a nat gateway allows instances without a public ip address to reach the internet
  default = false
}  

variable "single_nat_gateway" {
    default = true
    description = "just create one nat gateway for use across all private subnets"
}

variable "one_nat_gateway_per_az" {
  description = "Create a NAT gateway is each AZ"
  default = false
}

variable "enable_ipv6" {
  description = "enable IPv6 in the VPC.  Amazon will randomly assign a /56 IPv6 netblock"
  default = false
  # currently the upstream module only adds an IPv6 cidr, no other bits
  # see https://github.com/terraform-aws-modules/terraform-aws-vpc/pull/21
  # ref: https://docs.aws.amazon.com/vpc/latest/userguide/get-started-ipv6.html
  # ref: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-migrate-ipv6.html
}

variable "enable_dns_hostnames" {
  description = "http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-dns.html"
  default = true
}
   
variable "enable_dns_support" {
  description = "http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-dns.html"
  default = true
}

variable "enable_s3_endpoint" {
    default = true
    description = "provision an S3 endpoint within the VPC"
    # ref: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints-s3.html
    # ref: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints.html
}

variable "enable_dynamodb_endpoint" {
  default = false
  description = "provision a DynamoDB endpoint within the VPC"
  # ref: https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints.html
}

variable "enable_vpn_gateway" {
  default = false
  description = "provision a VPN Gateway and attach it to the VPC"
}

variable "enable_dhcp_options" {
  default = false
  description = "Override default DHCP options?"
}

variable "dhcp_options_domain_name" {
  description = "Domain name if overriding DHCP options"
  # ref: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html#DHCPOptionSets
}

variable "dhcp_options_domain_name_servers" {
  type = "list"
  description = "Domain name servers if overriding DHCP options"
  default = ["AmazonProvidedDNS"]
  # yes, "AmazonProvidedDNS"  is a valid value for DHCP domain name servers
  # ref: https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html#AmazonDNS
}

variable "dhcp_options_ntp_servers" {
  # ref: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html#configure_ntp
  type = "list"
  description = "list of up to four ntp servers for the DHCP option set"
  default = ["169.254.169.123"]
}

variable "tags" {
  type = "map"
  description = "map(list) of tags add to everything we create with this module"
  default = {
    "terraform" = "true"
  }
}
