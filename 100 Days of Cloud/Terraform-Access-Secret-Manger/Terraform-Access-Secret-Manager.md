To enable secure retrieval of secrets, the Nautilus DevOps team needs to configure access to a secret in AWS Secrets Manager using IAM roles and policies. The objective is to allow EC2 instances to retrieve secrets securely. Please complete the following tasks:

Create a secret in AWS Secrets Manager named datacenter-app-secret with the following secret string:

{"db_user":"admin","db_pass":"supersecret"}

Create an IAM role named datacenter-app-role with EC2 as the trusted entity.

Attach an inline IAM policy named datacenter-app-policy that grants permission to retrieve the secret from AWS Secrets Manager.

Use the main.tf file (do not create a separate .tf file) to provision the IAM Role and IAM Policy.

Create the variables.tf file, ensure the following variables are defined in variables.tf file:

KKE_SECRET_NAME for the secret name.
KKE_SECRET_VALUE for the secret value.
KKE_ROLE_NAME for the IAM role name.
KKE_POLICY_NAME for the IAM policy name.
Create the outputs.tf file, and use the following:

KKE_secret_name: The secret name
KKE_role_name: The IAM role name
KKE_policy_name: The IAM policy name

Solution :

1. Create variables.tf file

```
variable "KKE_SECRET_NAME" {
  type    = string
  default = "datacenter-app-secret"
}

variable "KKE_SECRET_VALUE" {
  type      = string
  sensitive = true
  default   = "{\"db_user\":\"admin\",\"db_pass\":\"supersecret\"}"
}

variable "KKE_ROLE_NAME" {
  type    = string
  default = "datacenter-app-role"
}

variable "KKE_POLICY_NAME" {
  type    = string
  default = "datacenter-app-policy"
}
```

2. Create main.tf file

```
# 1. Create the Secret container
resource "aws_secretsmanager_secret" "app_secret" {
  name = var.KKE_SECRET_NAME
}

# 2. Add the Secret string (the actual credentials)
resource "aws_secretsmanager_secret_version" "app_secret_val" {
  secret_id     = aws_secretsmanager_secret.app_secret.id
  secret_string = var.KKE_SECRET_VALUE
}

# 3. Create the IAM Role with EC2 trust
resource "aws_iam_role" "app_role" {
  name = var.KKE_ROLE_NAME

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# 4. Attach an Inline Policy to the Role
resource "aws_iam_role_policy" "app_inline_policy" {
  name = var.KKE_POLICY_NAME
  role = aws_iam_role.app_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "secretsmanager:GetSecretValue"
        Effect   = "Allow"
        Resource = aws_secretsmanager_secret.app_secret.arn
      }
    ]
  })
}
```

3. Create outputs.tf file

```
output "KKE_secret_name" {
  value       = aws_secretsmanager_secret.app_secret.name
  description = "The name of the AWS Secret"
}

output "KKE_role_name" {
  value       = aws_iam_role.app_role.name
  description = "The name of the IAM Role"
}

output "KKE_policy_name" {
  value       = aws_iam_role_policy.app_inline_policy.name
  description = "The name of the Inline IAM Policy"
}
```

4. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
