# Terraform AWS Infrastructure

This project contains a Terraform configuration for deploying a multi-tier application infrastructure on AWS. The architecture includes a core compute layer using Amazon ECS with Fargate, a database layer with Amazon RDS and DynamoDB, and various networking and security configurations.

## Project Structure

The project is organized into several modules, each responsible for a specific aspect of the infrastructure:

- **networking/**: Contains the networking setup, including VPC, subnets, NAT Gateways, and Route Tables.
- **compute/**: Configures the compute resources, including ECS cluster, services, and auto-scaling.
- **database/**: Provisions the database resources, including RDS, DynamoDB, and ElastiCache.
- **security/**: Manages security groups, IAM roles, and compliance features.
- **ci_cd/**: Sets up CI/CD pipelines using CodePipeline and CodeBuild.
- **monitoring/**: Configures monitoring and logging for the infrastructure.

## Prerequisites

- Terraform 1.6+
- AWS Account
- AWS CLI configured with appropriate permissions

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd terraform-aws-infra
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Configure Variables**:
   Update the `variables.tf` files in each module to set your desired configurations.

4. **Plan the Deployment**:
   ```bash
   terraform plan
   ```

5. **Apply the Configuration**:
   ```bash
   terraform apply
   ```

6. **Access Outputs**:
   After deployment, you can find the public ALB DNS, ECS service name, RDS endpoint, and Redis endpoint in the outputs.

## Modules Overview

- **Networking Module**: Sets up the VPC and subnets required for the application.
- **Compute Module**: Deploys the ECS service and configures auto-scaling and logging.
- **Database Module**: Provisions RDS, DynamoDB, and ElastiCache for data storage.
- **Security Module**: Configures security groups and IAM roles for secure access.
- **CI/CD Module**: Integrates with CodePipeline and CodeBuild for automated deployments.

## Security & Compliance

This project includes configurations for AWS Config, Security Hub, and CloudTrail to ensure compliance and security best practices.

## Cost Optimization

The infrastructure is designed with cost optimization in mind, utilizing Spot Instances where applicable and implementing S3 lifecycle rules for log management.

## License

This project is licensed under the MIT License. See the LICENSE file for more details for more information.
