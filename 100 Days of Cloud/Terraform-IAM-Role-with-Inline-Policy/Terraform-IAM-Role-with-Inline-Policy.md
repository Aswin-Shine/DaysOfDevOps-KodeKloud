The Nautilus DevOps team is setting up IAM-based access control for internal AWS resources. They need to create an IAM Role and an IAM Policy using Terraform and attach the policy to the role.

Create an IAM Role named datacenter-role.

Create an IAM Policy named datacenter-policy that allows listing EC2 instances.

Attach the policy to the role

Create the main.tf file (do not create a separate .tf file) to provision a Role, policy and attach it.

Use the variables.tf file with the following:

KKE_ROLE_NAME: name of the role.
KKE_POLICY_NAME: name of the policy.
Use terraform.tfvarsfile to input the role and policy names.

Use outputs.tf file to output the following:

kke_iam_role_name: name of the role created.
kke_iam_policy_name: name of the policy ceated.

Solution :

1. Create terraform.tfvars file

```
KKE_ROLE_NAME   = "datacenter-role"
KKE_POLICY_NAME = "datacenter-policy"
```

2. Create variables.tf file

```
variable "KKE_ROLE_NAME" {
  description = "The name of the IAM role"
  type        = string
}

variable "KKE_POLICY_NAME" {
  description = "The name of the IAM policy"
  type        = string
}
```

3. Create main.tf file

```
# 1. Create the IAM Role
resource "aws_iam_role" "datacenter_role" {
  name = var.KKE_ROLE_NAME

  # Trust policy allowing EC2 service to assume this role
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

# 2. Create the IAM Policy
resource "aws_iam_policy" "datacenter_policy" {
  name        = var.KKE_POLICY_NAME
  description = "Policy allowing listing of EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# 3. Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "datacenter_attach" {
  role       = aws_iam_role.datacenter_role.name
  policy_arn = aws_iam_policy.datacenter_policy.arn
}
```

4. Create outputs.tf file

```
output "kke_iam_role_name" {
  value       = aws_iam_role.datacenter_role.name
  description = "The name of the IAM role"
}

output "kke_iam_policy_name" {
  value       = aws_iam_policy.datacenter_policy.name
  description = "The name of the IAM policy"
}
```

5. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
