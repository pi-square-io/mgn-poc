data "aws_vpc" "default" {
  default = true
}


data "aws_subnet_ids" "default_subnets" {
  vpc_id = data.aws_vpc.default.id
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

   owners = ["099720109477"] # Canonical
}
