# An E-Commerce AWS Infrastructure with Terraform

## Project Structure with Granular Modules

```
aws-ecommerce-terraform/
├── diagrams/
│   └── ecommerce-architecture.drawio
├── modules/
│   ├── networking/
│   │   ├── vpc/
│   │   ├── subnets/
│   │   ├── internet-gateway/
│   │   └── nat-gateway/
│   ├── compute/
│   │   ├── lambda/
│   │   ├── ecs/
│   │   ├── ec2/
│   │   └── api-gateway/
│   ├── database/
│   │   ├── rds/
│   │   ├── dynamodb/
│   │   └── elasticsearch/
│   ├── security/
│   │   ├── security-group/
│   │   ├── nacl/
│   │   ├── iam-role/
│   │   └── iam-policy/
│   ├── monitoring/
│   │   ├── cloudwatch/
│   │   └── xray/
│   ├── storage/
│   │   ├── s3/
│   │   └── cloudfront/
│   └── caching/
│       └── elasticache/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
├── scripts/
├── README.md
└── versions.tf
```

## Architecture Overview

![Architecture Diagram](./diagrams/ecommerce-architecture.drawio)

## Features

- Multi-environment support (dev/prod)
- Modular design for maximum reusability
- Secure by default (IAM least privilege, encrypted resources)
- Scalable architecture (Lambda, RDS Aurora, Elasticache)
- Full observability (CloudWatch, X-Ray)

## Deployment

### Prerequisites

- Terraform 1.0+
- AWS CLI configured
- AWS account with admin privileges

### Setup Dev Environment

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### Setup Prod Environment

```bash
cd environments/prod
terraform init
terraform plan
terraform apply -var="db_password=your_secure_password"
```

## Module Documentation

### Networking

- VPC with public/private subnets across multiple AZs
- Internet/NAT gateways
- Route tables

### Compute

- Lambda functions for serverless components
- API Gateway for REST API
- ECS/EC2 for containerized services (optional)

### Database

- RDS Aurora PostgreSQL for transactional data
- DynamoDB for sessions and high-velocity data
- Elasticsearch for product search

### Monitoring

- CloudWatch logs and metrics
- X-Ray for distributed tracing
- Alerts for critical metrics

## Customization

Edit the `terraform.tfvars` in each environment folder to adjust:

- Instance sizes
- Scaling parameters
- Feature flags

```

## Final Notes

1. **State Management**: For production, configure remote state with S3 backend and DynamoDB locking.

2. **Secrets Management**: Use AWS Secrets Manager or Parameter Store for database credentials in production.

3. **CI/CD Integration**: The modular structure makes it easy to integrate with CI/CD pipelines.

4. **Scaling**: The architecture includes auto-scaling components:
   - Lambda automatically scales
   - RDS Aurora can scale read replicas
   - ElastiCache improves performance under load

5. **Cost Optimization**:
   - Dev environment uses smaller instance types
   - Prod environment uses reserved instances where appropriate

This implementation provides a complete, production-ready e-commerce backend infrastructure that meets all the requirements from your test document while providing maximum flexibility through granular modules.

Would you like me to elaborate on any specific part or provide additional implementation details for any component?
```

## Personal NOTES

### Good Practice: Use a root module to call this module twice, passing in different values:

```
module "backend_prod" {
  source      = "./modules/ecs"
  environment = "prod"
  ...
}

module "backend_dev" {
  source      = "./modules/ecs"
  environment = "dev"
  ...
}


```
