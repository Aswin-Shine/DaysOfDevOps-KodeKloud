The DevOps team is designing a Terraform-based infrastructure to simulate real-world, production-grade deployments with strict adherence to best practices. The infrastructure must be reusable, modular, and environment-specific (dev and prod).

Requirements:

Create modules under modules/ named:

dynamodb:Provision a DynamoDB table named datacenter-<env>-table (based on the environment)(dev & prod), using id as the HASH key.
secretsmanager: to provision a Secrets Manager secret named datacenter-<env>-secret.
elasticsearch: to provision an Elasticsearch domain named datacenter-<env>-es.
Create a secret value datacenter-<env>-value.(dev & prod).

Each environment dev and prod MUST be located under /home/bob/terraform/env/. Terraform commands will be executed from within each environment directory.

Use absolute-path symbolic links (/home/bob/terraform/) in each environment dev/prod for the shared Terraform files main.tf, variables.tf, and shared modules. Within each environment directory, the modules/ directory MUST be a symbolic link pointing to /home/bob/terraform/modules.

Keep a separate terraform_config.tf in each environment to define environment-specific configuration modules, environment variables, overrides. This file should NOT be a symlink.
Use main.tf file under /home/bob/terraform to define all shared resources and environment-specific modules, ensuring clarity, modularity, and maintainability.

Use the variables.tf file under /home/bob/terraform with the following variables:

KKE_ENV: name of the Environment used.(dev or prod)
KKE_DYNAMODB_TABLE_NAME: name of the dynamodb table.
KKE_SECRET_NAME: name of the secret.
KKE_SECRET_VALUE: secret value.
KKE_ELASTICSEARCH_DOMAIN: domain of the elasticsearch.
Use dev.tfvars and prod.tfvars with respect to the variables.tf file under /home/bob/terraform/env/<env-name>/. Terraform plans will be executed using these files explicitly.

Use the following variables to output the following:

kke_table_name:exposes the name of the created DynamoDB table
kke_secret_arn :provides the ARN of the Secrets Manager secret
kke_elasticsearch_endpoint: returns the endpoint of the Elasticsearch domain

Solution :

File structure for this question would look like this.

```
/home/bob/terraform/
├── main.tf                    # Shared Root Orchestrator
├── variables.tf               # Shared Input Variable Schema
├── outputs.tf                 # Shared Output Variable Schema
├── modules/                   # Central Modules Directory
│   ├── dynamodb/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── secretsmanager/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── elasticsearch/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── env/
    ├── dev/
    │   ├── terraform_config.tf # Isolated Env Configuration (No Symlink)
    │   ├── dev.tfvars          # Isolated Input Variable Mappings (No Symlink)
    │   ├── main.tf            ---> Symlink to /home/bob/terraform/main.tf
    │   ├── variables.tf       ---> Symlink to /home/bob/terraform/variables.tf
    │   ├── outputs.tf         ---> Symlink to /home/bob/terraform/outputs.tf
    │   └── modules            ---> Symlink to /home/bob/terraform/modules/
    └── prod/
        ├── terraform_config.tf # Isolated Env Configuration (No Symlink)
        ├── prod.tfvars         # Isolated Input Variable Mappings (No Symlink)
        ├── main.tf            ---> Symlink to /home/bob/terraform/main.tf
        ├── variables.tf       ---> Symlink to /home/bob/terraform/variables.tf
        ├── outputs.tf         ---> Symlink to /home/bob/terraform/outputs.tf
        └── modules            ---> Symlink to /home/bob/terraform/modules/
```

1. Create a shell script to file to build the file structure (build-infra.sh)

```
#!/usr/bin/env bash
set -euo pipefail

# Define core directory path anchoring
BASE_DIR="/home/bob/terraform"

echo "📂 Initializing empty Terraform workspace skeleton under ${BASE_DIR}..."

# 1. Scaffold directory paths
mkdir -p "${BASE_DIR}/modules/dynamodb"
mkdir -p "${BASE_DIR}/modules/secretsmanager"
mkdir -p "${BASE_DIR}/modules/elasticsearch"
mkdir -p "${BASE_DIR}/env/dev"
mkdir -p "${BASE_DIR}/env/prod"

# ==============================================================================
# 2. CREATE EMPTY CENTRAL ROOT CONFIGURATIONS
# ==============================================================================
echo "📝 Creating empty shared root elements..."
touch "${BASE_DIR}/main.tf"
touch "${BASE_DIR}/variables.tf"
touch "${BASE_DIR}/outputs.tf"

# ==============================================================================
# 3. CREATE EMPTY INFRASTRUCTURE MODULE COMPONENT FILES
# ==============================================================================
echo "📦 Creating empty component module files..."

# DynamoDB Module
touch "${BASE_DIR}/modules/dynamodb/main.tf"
touch "${BASE_DIR}/modules/dynamodb/variables.tf"
touch "${BASE_DIR}/modules/dynamodb/outputs.tf"

# Secrets Manager Module
touch "${BASE_DIR}/modules/secretsmanager/main.tf"
touch "${BASE_DIR}/modules/secretsmanager/variables.tf"
touch "${BASE_DIR}/modules/secretsmanager/outputs.tf"

# Elasticsearch Module
touch "${BASE_DIR}/modules/elasticsearch/main.tf"
touch "${BASE_DIR}/modules/elasticsearch/variables.tf"
touch "${BASE_DIR}/modules/elasticsearch/outputs.tf"

# ==============================================================================
# 4. CREATE EMPTY ENVIRONMENT SPECIFIC FILES (NON-SYMLINKS)
# ==============================================================================
echo "🌐 Creating isolated environment configurations..."

# Dev configuration targets
touch "${BASE_DIR}/env/dev/terraform_config.tf"
touch "${BASE_DIR}/env/dev/dev.tfvars"

# Prod configuration targets
touch "${BASE_DIR}/env/prod/terraform_config.tf"
touch "${BASE_DIR}/env/prod/prod.tfvars"

# ==============================================================================
# 5. EXECUTE ABSOLUTE PATH SYMLINK HOOKUPS
# ==============================================================================
echo "🔗 Linking environmental boundaries via absolute path symlinks..."

for ENV in dev prod; do
  cd "${BASE_DIR}/env/${ENV}"
  ln -sf "${BASE_DIR}/main.tf" main.tf
  ln -sf "${BASE_DIR}/variables.tf" variables.tf
  ln -sf "${BASE_DIR}/outputs.tf" outputs.tf
  ln -sf "${BASE_DIR}/modules" modules
done

# Reset working pointer cleanly back to root
cd "${BASE_DIR}"

echo "======================================================================"
echo "✅ Empty modular layout generated successfully!"
echo "🌲 Ready for deployment mapping inside ${BASE_DIR}"
echo "======================================================================"
```

2. Run this script file

```
chmod +x build-infra.sh
./build-infra.sh
```

3. Edit variables.tf file (/home/bob/terraform/)

```
variable "KKE_ENV" {
  type        = string
  description = "Target deployment environment (dev or prod)"
}

variable "KKE_DYNAMODB_TABLE_NAME" {
  type        = string
  description = "The name of the DynamoDB table"
}

variable "KKE_SECRET_NAME" {
  type        = string
  description = "The name of the Secrets Manager secret"
}

variable "KKE_SECRET_VALUE" {
  type        = string
  description = "The database secret credential payload string"
  sensitive   = true
}

variable "KKE_ELASTICSEARCH_DOMAIN" {
  type        = string
  description = "The domain name for the Elasticsearch cluster"
}
```

4. Edit main.tf file (/home/bob/terraform/)

```
module "dynamodb" {
  source                  = "./modules/dynamodb"
  KKE_ENV                 = var.KKE_ENV
  KKE_DYNAMODB_TABLE_NAME = var.KKE_DYNAMODB_TABLE_NAME
}

module "secretsmanager" {
  source           = "./modules/secretsmanager"
  KKE_ENV          = var.KKE_ENV
  KKE_SECRET_NAME  = var.KKE_SECRET_NAME
  KKE_SECRET_VALUE = var.KKE_SECRET_VALUE
}

module "elasticsearch" {
  source                   = "./modules/elasticsearch"
  KKE_ENV                  = var.KKE_ENV
  KKE_ELASTICSEARCH_DOMAIN = var.KKE_ELASTICSEARCH_DOMAIN
}
```

5. Edit outputs.tf file (/home/bob/terraform/)

```
output "kke_table_name" {
  value       = module.dynamodb.kke_table_name
  description = "Exposes the name of the created DynamoDB table"
}

output "kke_secret_arn" {
  value       = module.secretsmanager.kke_secret_arn
  description = "Provides the ARN of the Secrets Manager secret"
}

output "kke_elasticsearch_endpoint" {
  value       = module.elasticsearch.kke_elasticsearch_endpoint
  description = "Returns the endpoint of the Elasticsearch domain"
}
```

6. Edit variables.tf file (/home/bob/terraform/modules/dynamodb)

```
variable "KKE_ENV" { type = string }
variable "KKE_DYNAMODB_TABLE_NAME" { type = string }
```

7. Edit main.tf file (/home/bob/terraform/modules/dynamodb)

```
resource "aws_dynamodb_table" "table" {
  name         = var.KKE_DYNAMODB_TABLE_NAME
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = var.KKE_ENV
    ManagedBy   = "Terraform"
  }
}
```

8. Edit outputs.tf file (/home/bob/terraform/modules/dynamodb)

```
output "kke_table_name" {
  value = aws_dynamodb_table.table.name
}
```

9. Edit variables.tf file (/home/bob/terraform/modules/secretsmanager)

```
variable "KKE_ENV" { type = string }
variable "KKE_SECRET_NAME" { type = string }
variable "KKE_SECRET_VALUE" { type = string }
```

10. Edit main.tf file (/home/bob/terraform/modules/secretsmanager)

```
resource "aws_secretsmanager_secret" "secret" {
  name                    = var.KKE_SECRET_NAME
  recovery_window_in_days = 0

  tags = {
    Environment = var.KKE_ENV
    ManagedBy   = "Terraform"
  }
}

resource "aws_secretsmanager_secret_version" "secret_val" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = var.KKE_SECRET_VALUE
}
```

11. Edit outputs.tf file (/home/bob/terraform/modules/secretsmanager)

```
output "kke_secret_arn" {
  value = aws_secretsmanager_secret.secret.arn
}
```

12. Edit variables.tf file (/home/bob/terraform/modules/elasticsearch)

```
variable "KKE_ENV" { type = string }
variable "KKE_ELASTICSEARCH_DOMAIN" { type = string }
```

13. Edit main.tf file (/home/bob/terraform/modules/elasticsearch)

```
resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.KKE_ELASTICSEARCH_DOMAIN
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t3.medium.elasticsearch"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  tags = {
    Environment = var.KKE_ENV
    ManagedBy   = "Terraform"
  }
}
```

14. Edit outputs.tf file (/home/bob/terraform/modules/elasticsearch)

```
output "kke_elasticsearch_endpoint" {
  value = aws_elasticsearch_domain.es.endpoint
}
```

15. Edit terraform config file in env/dev/ (terraform_config.tf)

```
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

16. Edit dev.tfvars file (env/dev/)

```
KKE_ENV                  = "dev"
KKE_DYNAMODB_TABLE_NAME = "datacenter-dev-table"
KKE_SECRET_NAME          = "datacenter-dev-secret"
KKE_SECRET_VALUE         = "datacenter-dev-value"
KKE_ELASTICSEARCH_DOMAIN = "datacenter-dev-es"
```

17. Edit terraform config file in env/prod/ (terraform_config.tf)

```
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

16. Edit dev.tfvars file (env/prod/)

```
KKE_ENV                  = "prod"
KKE_DYNAMODB_TABLE_NAME = "datacenter-prod-table"
KKE_SECRET_NAME          = "datacenter-prod-secret"
KKE_SECRET_VALUE         = "datacenter-prod-value"
KKE_ELASTICSEARCH_DOMAIN = "datacenter-prod-es"
```

17. Init/Apply the terraform file the dev environment

```
cd env/dev
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars" -auto-approve
```

18. Init/Apply the terraform file the prod environment

```
cd env/prod
terraform init
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars" -auto-approve
```
