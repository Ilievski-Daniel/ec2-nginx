# Terraform AWS Web Server Configuration

This Terraform configuration deploys a web server on AWS using an Ubuntu 20.04 LTS AMI and installs Nginx. 

It also creates a security group allowing inbound HTTP, HTTPS and SSH traffic and generates an SSH key pair for accessing the instance.

## Prerequisites

Before running this Terraform configuration, ensure that you have the following:

- Terraform installed on your machine.
- AWS CLI configured with valid credentials.
- SSH key pair created (optional if you want to use the generated SSH key).

## Configuration

1. Clone this repository and navigate to the project directory.

2. Update the `variables.tf` file to customize the configuration, if desired.

3. Run `terraform init` to initialize the Terraform project and download the required provider plugins.

4. Run `terraform plan` to preview the execution plan and verify the changes that will be applied.

5. Run `terraform apply` to create the AWS resources based on the Terraform configuration. Confirm the changes when prompted.

6. Once the deployment is complete, Terraform will output the public IP address of the web server instance.

## Accessing the Web Server

To access the web server:

1. Open a web browser and enter the public IP address of the web server instance obtained from the Terraform output.

2. If the deployment was successful, you should see the default Nginx welcome page.

## GitHub Actions Pipeline

This project includes a GitHub Actions pipeline that automates the Terraform infrastructure deployment. 

The pipeline is triggered on every push to any branch and on every pull request.

### Pipeline Steps

- **Lint**: Performs a lint check on the Terraform code to ensure consistent formatting using `terraform fmt`.

**Note**: If needed in the future, more steps can be added.

## Contact
For any questions or inquiries, please contact: [Daniel Ilievski](https://www.linkedin.com/in/danielilievski/)