The Nautilus DevOps team is adopting strict naming conventions for all IAM resources using Terraform. They’ve asked for help enforcing lowercase, hyphenated names based on inputs like project and team.

Your task as a DevOps engineer is to complete the following using Terraform:

Create an IAM User The user name must be derived using the format project-team-user, all lowercase, and non-alphanumeric characters (except dashes) replaced with -.

Create an IAM Role Use the same naming logic for the role name, ending in -role, and attach an assume role policy for EC2.

Tagging: Both resources must be tagged with:

Project: devops
Team: dev-team
ManagedBy: Terraform
Env: dev
Additionally, the IAM role should have:

RoleType: EC2
Use locals block within main.tf to:

Derive sanitized project/team names
Create the resource name prefix
Define reusable common tags
Create the main.tf file (do not create a separate .tf file) to provision the IAM Role & User as per the required values.

Use variables.tffile with the following:

KKE_PROJECT: name of the project(must be non-empty).
KKE_TEAM: name of the team (only letters, digits, dashes or underscores)
KKE_ENVIRONMENT: name of the environment
Use terraform.tfvarsfile to input the values.

Use outputs.tffile to output the following:

kke_user_name: name of the created user.
kke_role_name: name of the created role.
kke_tags_applied: tags applied to the IAM User.

Solution :

1. Create terraform.tfvars file

```
KKE_PROJECT     = "devops"
KKE_TEAM        = "dev-team"
KKE_ENVIRONMENT = "dev"
```

2. Create variables.tf file

```
variable "KKE_PROJECT" {
  description = "Name of the project"
  type        = string
  validation {
    condition     = length(var.KKE_PROJECT) > 0
    error_message = "The project name must not be empty."
  }
}

variable "KKE_TEAM" {
  description = "Name of the team (only letters, digits, dashes or underscores)"
  type        = string
}

variable "KKE_ENVIRONMENT" {
  description = "Name of the environment"
  type        = string
}
```

3. Create main.tf file

```
locals {
  # Sanitize: lowercase and replace non-alphanumeric (except -) with hyphens
  clean_project = lower(replace(var.KKE_PROJECT, "/[^a-zA-Z0-9-]/", "-"))
  clean_team    = lower(replace(var.KKE_TEAM, "/[^a-zA-Z0-9-]/", "-"))

  # Name Construction
  base_name = "${local.clean_project}-${local.clean_team}"
  user_name = "${local.base_name}-user"
  role_name = "${local.base_name}-role"

  # Common Tags
  common_tags = {
    Project   = var.KKE_PROJECT
    Team      = var.KKE_TEAM
    ManagedBy = "Terraform"
    Env       = var.KKE_ENVIRONMENT
  }
}

# 1. IAM User
resource "aws_iam_user" "nautilus_user" {
  name = local.user_name
  tags = local.common_tags
}

# 2. IAM Role for EC2
resource "aws_iam_role" "nautilus_role" {
  name = local.role_name

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

  tags = merge(
    local.common_tags,
    {
      RoleType = "EC2"
    }
  )
}
```

4. Create outputs.tf file

```
output "kke_user_name" {
  value       = aws_iam_user.nautilus_user.name
  description = "The name of the created IAM user"
}

output "kke_role_name" {
  value       = aws_iam_role.nautilus_role.name
  description = "The name of the created IAM role"
}

output "kke_tags_applied" {
  value       = aws_iam_user.nautilus_user.tags
  description = "The tags applied to the IAM User"
}
```

5. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
