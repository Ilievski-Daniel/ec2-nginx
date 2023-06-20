# Configure the AWS provider
provider "aws" {
  region = "eu-west-1"
}

# Data source to retrieve the latest Ubuntu 20.04 LTS AMI
data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Generate an SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh_key_pair" {
  key_name   = "my-ssh-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Output the private key to a file
resource "null_resource" "output_private_key" {
  provisioner "local-exec" {
    command = "echo '${tls_private_key.ssh_key.private_key_pem}' > private_key.pem"
  }

  depends_on = [aws_key_pair.ssh_key_pair]
}

# Create an EC2 instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = "t2.medium"

  key_name = aws_key_pair.ssh_key_pair.key_name

  tags = {
    Name = "nginx-web-server"
  }

  # Configure the security group
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]

  # Provision the user data script to install Nginx
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              EOF
}

# Create a security group allowing inbound HTTP traffic
resource "aws_security_group" "web_server_sg" {
  name        = "web-server-sg"
  description = "Allow HTTP inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Output the public IP of the EC2 instance
output "public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "Public IP address of the web server"
}
