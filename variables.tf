##### AWS Global Variables #####

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

##### SG Variables #####

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