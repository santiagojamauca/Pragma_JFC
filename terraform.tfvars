project     = "ecom"
environment = "dev"
region      = "us-east-1"

# === Domain & Certificate options ===
# === Terraform creates and validates the ACM certificate in us-east-1 (Route53 DNS) ===
create_acm     = true
domain_name    = "shop.example.com"
hosted_zone_id = "Z123456ABCDEFG" # Route53 hosted zone id
include_www    = true

# === Backend Lambda artifact ===
lambda_code_bucket = "my-artifacts-bucket"
lambda_code_key    = "backend.zip"
lambda_runtime     = "python3.11"
lambda_handler     = "app.handler"

# === Database ===
db_engine         = "aurora-postgresql"
db_engine_version = "15"
db_min_capacity   = 0.5
db_max_capacity   = 2

# === Observability ===
alarm_email = null

# === Hosted zone ===
create_hosted_zone = true         
domain_zone_name   = "example.com"
