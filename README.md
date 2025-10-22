# Infraestructura e-commerce serverless en AWS (Terraform)

Plataforma serverless modularizada en Terraform:
- **network**: VPC, subnets, IGW, ruteo, endpoints (Secrets/Logs).
- **s3_cloudfront**: S3 + CloudFront con OAC; usa certificado ACM en `us-east-1`.
- **lambda_api**: Lambda + API Gateway HTTP (artefacto desde S3).
- **rds_aurora**: Aurora Serverless v2 (PostgreSQL) + Secrets Manager.
- **observability**: alarmas CloudWatch (Lambda y API).
- **route53**: creación/lookup de Hosted Zone.
- **acm**: certificado público con validación DNS.

## Variables y `terraform.tfvars`
Defínelas en la raíz (`variables.tf`) y parametriza con `terraform.tfvars`:
```hcl
project = "ecom"
environment = "dev"
region = "us-east-1"

create_acm  = true
domain_name = "shop.example.com"
include_www = true

# Hosted Zone (elige A/B)
create_hosted_zone = true
domain_zone_name   = "example.com"
# hosted_zone_id   = "Z123..."  # (si usas una existente, quita lo anterior)

lambda_code_bucket = "my-artifacts-bucket"
lambda_code_key    = "backend.zip"

db_engine         = "aurora-postgresql"
db_engine_version = "15"
db_min_capacity   = 0.5
db_max_capacity   = 2

alarm_email = null
```

## Flujo
```bash
terraform fmt -recursive
terraform init -upgrade
terraform validate
terraform plan -var-file=terraform.tfvars -out=tfplan.bin
terraform show -no-color tfplan.bin > tfplan.txt
```

## Notas de diseño y costos
- Sin NAT: VPC Endpoints (Secrets/Logs) para ahorrar.
- Certificado ACM en `us-east-1` (CloudFront).
- OAC: bucket S3 privado, acceso solo desde CloudFront.
- Aurora v2: ajusta `min/max_capacity`; destruye cuando no se use.
- Route53 HZ: crear/usar existente; registros A/AAAA alias a CloudFront.
