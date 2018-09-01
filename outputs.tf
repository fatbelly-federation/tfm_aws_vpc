#####$################# OUTPUTS #########################
##  outputs will be written to the remote state file   ##
##  this allows other modules to pull in these values  ##
#########################################################

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_name" {
  value = "${var.vpc_name}"
}

output "vpc_azs" {
  value = "${local.azs}"
}

output "vpc_cidr_block" {
  value = "${var.vpc_cidr_block}"
}

output "trusted_subnets" {
  value = ["${var.trusted_subnets}"]
}

output "public_subnets" {
  value = ["${var.public_subnets}"]
}

output "private_subnets" {
  value = ["${var.private_subnets}"]
}

output "public_subnet_ids" {
  value = ["${module.vpc.public_subnets}"]
}

output "private_subnet_ids" {
  value = ["${module.vpc.private_subnets}"]
}

output "public_route_table_ids" {
  value = ["${module.vpc.public_route_table_ids}"]
}

output "private_route_table_ids" {
  value = ["${module.vpc.private_route_table_ids}"]
}

output "vpc_route_table_ids" {
  value = ["${module.vpc.public_route_table_ids}", "${module.vpc.private_route_table_ids}"]
}
