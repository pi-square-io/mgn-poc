/*======creating three ec2 instances with appach serves, each one of them running a hello world script on php   ========*/

/*============== creating three ec2 instance with appach server using user data   =================*/
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region = var.region
}
/*============ The VPC =================*/
resource "aws_vpc" "vpc" {
  # cidr_block           = var.vpc_cidr 
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.environment}-vpc"
  }
}
/*============== subnets  =================*/
# --------- public subnet -------------
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zone
  # cidr_block        = cidrsubnet(var.vpc_cidr, 4, 1)
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.environment}-public_subnet"
  }
}
