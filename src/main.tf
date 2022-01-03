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
  tags = merge(var.project_tags, { Name = "generated_key-${count.index}" })
  key_name = "generated_key-${count.index}"
  public_key = "tls_private_key.private_key.{count.index}.public_key_openssh"
}


resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "aws_key_pair.generated_key.key_name-${count.index}"

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