# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}

# Data source to retrieve the latest Ubuntu 20.04 LTS AMI
data "aws_ami" "ubuntu_ami" {
  most_recent = var.ami_most_recent
  owners      = var.ami_owners

  filter {
    name   = "name"
    values = var.ami_name_filter
  }

  filter {
    name   = "virtualization-type"
    values = var.ami_virtualization_type
  }
}

# Generate an SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = var.ssh_key_algorithm
  rsa_bits  = var.ssh_key_rsa_bits
}

resource "aws_key_pair" "ssh_key_pair" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Output the private key to a file
resource "null_resource" "output_private_key" {
  provisioner "local-exec" {
    command = "echo '${tls_private_key.ssh_key.private_key_pem}' > ${var.private_key_file_path}"
  }

  provisioner "local-exec" {
    command = "chmod 400 ${var.private_key_file_path}"
  }

  depends_on = [aws_key_pair.ssh_key_pair]
}

# Create an EC2 instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ssh_key_pair.key_name
  tags          = var.instance_tags

  # Configure the security group
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]

  # Provision the user data script to install Nginx
  user_data = file(var.user_data_file_path)
}

# Create a security group allowing inbound HTTP traffic
resource "aws_security_group" "web_server_sg" {
  name        = var.web_server_sg_name
  description = var.web_server_sg_description

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }
}

# Output the public IP of the EC2 instance
output "public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "Public IP address of the web server"
}
