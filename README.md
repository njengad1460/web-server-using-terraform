AWS Web Server Deployment with Terraform
This project automates the deployment of a web server on AWS using Terraform. It leverages the existing Default VPC while creating a dedicated custom subnet for the infrastructure.

Architecture Overview
The deployment consists of the following components:

VPC: Utilizes the AWS Default VPC (fetched via Data Source).

Subnet: A new custom public subnet created within the Default VPC (172.31.100.0/24).

Security Group: Acts as a firewall allowing:

HTTP (80) and HTTPS (443) for web traffic.

SSH (22) for secure remote access.

EC2 Instance: A t3.micro instance running Amazon Linux 2023.

Prerequisites
Terraform installed.

AWS CLI configured with appropriate permissions.

An existing AWS Key Pair named my-web-server-key-pair.

How to Deploy
Initialize Terraform:

Bash
terraform init
Validate the configuration:

Bash
terraform validate
View the execution plan:

Bash
terraform plan
Apply the changes:

Bash
terraform apply
Usage
Once the deployment is complete, you can access the server via SSH