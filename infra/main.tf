terraform {
  backend "s3" {
    bucket = "capstone-terraform-state-backend"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform_state"
  }
}

# Set provider
provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
}

module "elb" {
  source                        = "./modules/elb"
  prj_capstone_vpc_id           = module.vpc.capstone_vpc_id
  prj_capstone_sg_id            = module.vpc.capstone_security_group_id
  prj_capstone_sub_id           = module.vpc.capstone_subnet_main
  prj_capstone_sub_secondary_id = module.vpc.capstone_subnet_secondary
}

module "ecr" {
  source = "./modules/ecr"
  prj_capstone_ecr_name         = var.aws_ecr_repo_name
  prj_capstone_sg_id            = module.vpc.capstone_security_group_id
  prj_capstone_sub_id           = module.vpc.capstone_subnet_main
  prj_capstone_sub_secondary_id = module.vpc.capstone_subnet_secondary
  prj_capstone_alb_tg_arn       = module.elb.capstone_alb_tg_arn
}
