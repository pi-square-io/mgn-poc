locals {
  stage = terraform.workspace
  tags  = merge(var.project_tags, { STAGE = local.stage })
}


resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
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