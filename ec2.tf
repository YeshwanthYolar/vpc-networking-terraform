# Generate an SSH Key Pair
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2-1"  # Replace with your desired key name
  public_key = tls_private_key.key_pair.public_key_openssh
}

# Generate a Private Key using the TLS provider
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_key_pair.key_name
  subnet_id     = aws_subnet.subnet-1.id 
  security_groups = [
    aws_security_group.public_sg.id 
  ]

# To add user data to install and run simple nginx webserver
user_data = <<-EOT
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOT

  tags = {
    Name = "WebServer"
  }

  
}


# for output
output "ec2_instance_public_ip" {
  value = aws_instance.web_server.public_ip
}




