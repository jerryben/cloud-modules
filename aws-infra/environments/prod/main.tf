
module "vpc" {
  source = "../../modules/networking/vpc"

  cidr_block  = "10.1.0.0/16"
  environment = "prod"
  tags = {
    Environment = "prod"
    Project     = "ecommerce"
  }
}

module "subnets" {
  source = "../../modules/networking/subnets"

  vpc_id          = module.vpc.vpc_id
  environment     = "prod"
  public_subnets  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  private_subnets = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]

  tags = {
    Environment = "prod"
    Project     = "ecommerce"
  }
}

module "product_lambda" {
  source = "../../modules/compute/lambda"

  environment   = "prod"
  function_name = "product-service"
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  source_file   = "../../dist/product-service.zip"
  environment_vars = {
    DB_HOST = module.rds.endpoint
  }

  tags = {
    Environment = "prod"
    Project     = "ecommerce"
  }
}

module "rds" {
  source = "../../modules/database/rds"

  environment         = "prod"
  cluster_name        = "ecommerce-db"
  engine              = "aurora-postgresql"
  database_name       = "ecommerce"
  master_username     = "admin"
  master_password     = var.db_password # From secrets management
  skip_final_snapshot = false
  subnet_ids          = module.subnets.private_subnet_ids
  security_group_ids  = [module.product_db_sg.security_group_id]

  tags = {
    Environment = "prod"
    Project     = "ecommerce"
  }
}



# copilot eg 
module "network" {
  source               = "../modules/network"
  vpc_cidr             = "10.1.0.0/16"
  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  private_subnet_cidrs = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
  environment          = "prod"
}
