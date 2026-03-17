# Defining the provider

provider "aws" {
  region = "us-east-1"
}

# look up for the existing vpc

data "aws_vpc" "default" {
  default = true
}

# creating a new custom subnet inside the default VPC

resource "aws_subnet" "custom_web_subnet" {
  vpc_id = data.aws_vpc.default.id

  # choose CIDR that does not overlab with existing default subnet
  cidr_block              = "172.31.100.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true # Allaws HTTP/S and SSH access from the internet
  tags = {
    Name = "My-Custom-Web-Subnet"
  }
}
# Security group firewall 

resource "aws_security_group" "web_sg" {
  name   = "custom_web_sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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

# creating the new ec2 instance 
resource "aws_instance" "web_server" {
  ami                    = "ami-02dfbd4ff395f2a1b"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.custom_web_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "my-web-server-key-pair" # this aready exists in my account
  tags = {
    Name = "WebServer-CustomSubnet"
  }
}

# Outputs the Public IP the terminal after terraform appy
output "web_public_ip" {
  value = aws_instance.web_server.public_ip
}