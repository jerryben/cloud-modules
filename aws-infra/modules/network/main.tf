# VPC
module "vpc" {
  source      = "./vpc"
  cidr_block  = var.vpc_cidr
  environment = var.environment
}

# Subnets
module "subnets" {
  source               = "./subnets"
  vpc_id               = module.vpc.vpc_id
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  environment          = var.environment
}

# Internet Gateway
module "internet_gateway" {
  source      = "./internet-gateway"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
}

# NAT Gateway
module "nat_gateway" {
  source            = "./nat-gateway"
  public_subnet_ids = module.subnets.public_subnet_ids
  environment       = var.environment
}

# Route Tables
module "route_tables" {
  source              = "./route-tables"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.subnets.public_subnet_ids
  private_subnet_ids  = module.subnets.private_subnet_ids
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  nat_gateway_ids     = module.nat_gateway.nat_gateway_ids
  environment         = var.environment
}
