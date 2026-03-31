The DevOps team has been tasked with creating a secure DynamoDB table and enforcing fine-grained access control using IAM. This setup will allow secure and restricted access to the table from trusted AWS services only.

As a member of the Nautilus DevOps Team, your task is to perform the following using Terraform:

1. Create a DynamoDB Table: Create a table named devops-table with minimal configuration.

2. Create an IAM Role: Create an IAM role named devops-role that will be allowed to access the table.

3. Create an IAM Policy: Create a policy named devops-readonly-policy that should grant read-only access (GetItem, Scan, Query) to the specific DynamoDB table and attach it to the role.

4. Create the main.tf file (do not create a separate .tf file) to provision the table, role, and policy.

5. Create the variables.tf file with the following variables:

KKE_TABLE_NAME: name of the DynamoDB table
KKE_ROLE_NAME: name of the IAM role
KKE_POLICY_NAME: name of the IAM policy
Create the outputs.tf file with the following outputs:

kke_dynamodb_table: name of the DynamoDB table
kke_iam_role_name: name of the IAM role
kke_iam_policy_name: name of the IAM policy
Define the actual values for these variables in the terraform.tfvars file.

Ensure that the IAM policy allows only read access and restricts it to the specific DynamoDB table created.

Solution :

1. Create terraform.tfvars file

```
KKE_TABLE_NAME  = "devops-table"
KKE_ROLE_NAME   = "devops-role"
KKE_POLICY_NAME = "devops-readonly-policy"
```

2. Create variables.tf file

```
variable "KKE_TABLE_NAME" {
  type = string
}

variable "KKE_ROLE_NAME" {
  type = string
}

variable "KKE_POLICY_NAME" {
  type = string
}
```

3. Create main.tf file

```
# 1. DynamoDB Table
resource "aws_dynamodb_table" "devops_table" {
  name           = var.KKE_TABLE_NAME
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# 2. IAM Role
resource "aws_iam_role" "devops_role" {
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
      },
    ]
  })
}

# 3. IAM Policy (Read-Only)
resource "aws_iam_policy" "devops_read_only_policy" {
  name        = var.KKE_POLICY_NAME
  description = "Read-only access to specific DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.devops_table.arn
      },
    ]
  })
}

# 4. Attach Policy to Role
resource "aws_iam_role_policy_attachment" "role_attach" {
  role       = aws_iam_role.devops_role.name
  policy_arn = aws_iam_policy.devops_read_only_policy.arn
}
```

4. Create outputs.tf file

```
output "kke_dynamodb_table" {
  value = aws_dynamodb_table.devops_table.name
}

output "kke_iam_role_name" {
  value = aws_iam_role.devops_role.name
}

output "kke_iam_policy_name" {
  value = aws_iam_policy.devops_read_only_policy.name
}
```

5. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
