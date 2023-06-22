##### AWS Global Variables #####

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

#### AMI Variables #####

variable "ami_most_recent" {
  description = "Retrieve the most recent AMI"
  type        = bool
  default     = true
}

variable "ami_owners" {
  description = "List of AMI owners"
  type        = list(string)
  default     = ["099720109477"]
}

variable "ami_name_filter" {
  description = "Name filter for AMI"
  type        = list(string)
  default     = ["ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"]
}

variable "ami_virtualization_type" {
  description = "Virtualization type filter for AMI"
  type        = list(string)
  default     = ["hvm"]
}

##### Security Group Variables #####

variable "web_server_sg_name" {
  description = "Name of the web server security group"
  type        = string
  default     = "web-server-sg"
}

variable "web_server_sg_description" {
  description = "Description of the web server security group"
  type        = string
  default     = "Allow HTTP, HTTPS, SSH."
}

variable "ingress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    http_ingress = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    custom_ingress = {
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    ssh_ingress = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "egress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {
    all_traffic = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

##### SSH Key Variables #####

variable "ssh_key_algorithm" {
  description = "Algorithm for SSH key pair generation"
  type        = string
  default     = "RSA"
}

variable "ssh_key_rsa_bits" {
  description = "Number of bits for RSA SSH key pair"
  type        = number
  default     = 4096
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "my-ssh-key"
}

variable "private_key_file_path" {
  description = "Path and filename where the private key file will be stored"
  type        = string
  default     = "~/.ssh/private_key.pem"
}

##### EC2 Instance Variables #####

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.medium"
}

variable "instance_tags" {
  description = "Tags for the EC2 instance"
  type        = map(string)
  default     = {
    Name = "nginx-web-server"
  }
}

variable "user_data_file_path" {
  description = "File path to the user data script"
  type        = string
  default     = "user_data.sh"
}