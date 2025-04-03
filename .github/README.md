# GitHub Actions Setup

This directory contains GitHub Actions workflows for automating Terraform operations.

## Required Secrets

To use these workflows, you need to set up the following secrets in your GitHub repository:

1. Go to your GitHub repository
2. Click on "Settings" > "Secrets and variables" > "Actions"
3. Add the following secrets:

| Secret Name | Description |
|-------------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS Access Key ID with appropriate permissions |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Access Key |
| `AWS_REGION` | AWS Region (e.g., us-east-1) |

## Workflows

### terraform.yml

This workflow runs on:
- Push to the main branch
- Pull requests to the main branch

It performs:
- Terraform format check
- Terraform initialization
- Terraform validation
- Terraform plan (on pull requests)
- Terraform apply (on push to main)

### terraform-destroy.yml

This workflow can be manually triggered to destroy infrastructure for a specific environment.

### terraform-security.yml

This workflow runs:
- On push to the main branch
- On pull requests to the main branch
- Weekly on Sundays

It performs security scanning using:
- tfsec
- Checkov

## Environment Protection

For production environments, it's recommended to set up environment protection rules:

1. Go to your GitHub repository
2. Click on "Settings" > "Environments"
3. Create environments for dev, staging, and prod
4. Add required reviewers for each environment
5. Optionally, add deployment branch policies 