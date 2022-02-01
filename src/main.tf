locals {
  stage = terraform.workspace
  tags  = merge(var.project_tags, { STAGE = local.stage })
}


resource "tls_private_key" "private_key" {
  count     = var.instance_count
  algorithm = "RSA"
  rsa_bits  = 4096
}



resource "aws_key_pair" "generated_key" {
  count      = var.instance_count
  key_name   = "generated_key-${count.index}"
  public_key = tls_private_key.private_key[count.index].public_key_openssh
  tags       = merge(var.project_tags, { Name = "generated_key-${count.index}" })
}

resource "local_file" "private_key" {
    count      = var.instance_count
    content  = tls_private_key.private_key[count.index].private_key_pem
    filename = "generated_key-${count.index}.pem"
}
resource "aws_security_group" "security_group" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "security_group"
  }
}
resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "generated_key-${count.index}"

  user_data     = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  sudo apt install php libapache2-mod-php
  echo "<?php echo 'Hello server' ?>" > /var/www/html/index.php
  EOF

  tags = merge(var.project_tags, { Name = "Server-${count.index}" })
}