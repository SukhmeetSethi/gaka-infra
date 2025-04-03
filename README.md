# GAKA Infrastructure

This repository contains the Terraform configurations for the GAKA infrastructure on AWS.

## Prerequisites

- WSL Ubuntu 24.04
- AWS CLI
- Terraform (latest version)
- AWS Account and credentials

## Setup Instructions

1. Install required packages in WSL Ubuntu:
   ```bash
   sudo apt update && sudo apt upgrade -y
   sudo apt install -y curl unzip
   ```

2. Install AWS CLI:
   ```bash
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install
   ```

3. Install Terraform:
   ```bash
   wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install terraform
   ```

4. Configure AWS credentials:
   ```bash
   aws configure
   ```
   Enter your AWS Access Key ID, Secret Access Key, and default region.

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the planned changes:
   ```bash
   terraform plan
   ```

3. Apply the changes:
   ```bash
   terraform apply
   ```

4. To destroy the infrastructure:
   ```bash
   terraform destroy
   ```

## Project Structure

- `main.tf`: Main Terraform configuration file
- `variables.tf`: Variable declarations
- `terraform.tfvars`: Variable values
- `.gitignore`: Git ignore rules for Terraform
- `modules/`: Directory containing modularized Terraform resources
  - `vpc/`: VPC-related resources
  - `s3/`: S3-related resources

## GitHub Actions CI/CD

This project includes GitHub Actions workflows for automated Terraform operations:

### Workflows

1. **Terraform CI/CD** (`.github/workflows/terraform.yml`):
   - Runs on push to main and pull requests
   - Performs format, init, validate, plan, and apply operations
   - Automatically applies changes when merged to main

2. **Terraform Destroy** (`.github/workflows/terraform-destroy.yml`):
   - Manually triggered workflow to destroy infrastructure
   - Allows selecting the environment to destroy

3. **Terraform Security Scan** (`.github/workflows/terraform-security.yml`):
   - Runs security scans using tfsec and Checkov
   - Executes on push, pull requests, and weekly

### Setup

To use these workflows, you need to set up the following secrets in your GitHub repository:

1. Go to your GitHub repository
2. Click on "Settings" > "Secrets and variables" > "Actions"
3. Add the following secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION`

For more details, see [GitHub Actions Setup](.github/README.md).

## Important Notes

- Make sure to keep your AWS credentials secure and never commit them to version control
- Review the planned changes before applying them
- Use appropriate AWS regions based on your requirements
- Consider using workspaces for different environments (dev, staging, prod) 