The Nautilus DevOps team needs to securely manage sensitive information using AWS Secrets Manager. The task is to create a secret in AWS Secrets Manager using Terraform. Store a database password securely in this secret. Ensure the password is passed as a sensitive Terraform variable, and it should not appear in Terraform logs or output without being marked sensitive.

Requirements:

Create an AWS Secrets Manager secret named xfusion-db-password.

Store the database password SuperSecretPassword123! in the secret using Terraform.

Mark the Terraform variable for the password as sensitive.

Do not expose the actual password in Terraform outputs without marking it sensitive.

Create main.tf file (do not create a separate .tf file) to provision a Secret and add the database password in it.

Use variables.tffile for the following:

KKE_DB_PASSWORD: database password stored in secrets manager.
Create a terraform.tfvars to input the database password.

Use outputs.tf file to output the following:

kke_secret_arn: arn of the secret created.

kke_secret_string: database password.

Solution :

1. Create terraform.tfvars file

```
KKE_DB_PASSWORD = "SuperSecretPassword123!"
```

2. Create variables.tf file

```
variable "KKE_DB_PASSWORD" {
  type        = string
  description = "The database password to be stored in Secrets Manager"
  sensitive   = true
}
```

3. Create main.tf file

```
provider "aws" {
  region = "us-east-1"
}

# 1. Create the Secret container
resource "aws_secretsmanager_secret" "db_password" {
  name        = "xfusion-db-password"
  description = "Database password for xfusion application"

  tags = {
    Name = "xfusion-db-password"
  }
}

# 2. Create the Secret Version (storing the actual password)
resource "aws_secretsmanager_secret_version" "db_password_val" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.KKE_DB_PASSWORD
}
```

4. Create outputs.tf file

```
output "kke_secret_arn" {
  value       = aws_secretsmanager_secret.db_password.arn
  description = "The ARN of the created secret"
}

output "kke_secret_string" {
  value       = aws_secretsmanager_secret_version.db_password_val.secret_string
  description = "The database password stored in the secret"
  sensitive   = true
}
```

5. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
