The DevOps team needs to build a secure, modular multi-tier AWS infrastructure to support a modern cloud-native application stack using Terraform. As part of this requirement, use only allowed AWS services and ensure secure variable usage.
As a member of the Nautilus DevOps Team, your tasks are:
Create a DynamoDB Table: Provision a table named datacenter-app-table with minimal configuration.

Create an SNS Topic: Set up a topic named datacenter-app-topic for messaging and notifications.
Create an SSM Parameter: Store a sensitive configuration value in AWS SSM Parameter Store under the name /datacenter/app/config.
Create main.tf file (do not create a separate .tf file) to provision a dynamoDB table, sns-topic and ssm parameter.
Use variables.tf file with the following:
KKE_ENVIRONMENT: devEnvironment.

KKE_DYNAMODB_TABLE_NAME: name of dynamodb table.
KKE_SNS_TOPIC_NAME: name of the sns topic.
KKE_SSM_PARAM_NAME: name of the SSM parameter.
Create terraform.tfvars to input the name of the variables.
Use outputs.tf file to output the following:
kke_dynamodb_table_name: name of the dynamodb table.

kke_sns_topic_arn: arn of the sns-topic created.
kke_ssm_parameter_name: name of the ssm parameter created.

Solution :

1. Create terraform.tfvars file

```
KKE_ENVIRONMENT         = "devEnvironment"
KKE_DYNAMODB_TABLE_NAME = "datacenter-app-table"
KKE_SNS_TOPIC_NAME      = "datacenter-app-topic"
KKE_SSM_PARAM_NAME      = "/datacenter/app/config"
```

2. Create variables.tf file

```
variable "KKE_ENVIRONMENT" {
  description = "The deployment environment"
  type        = string
}

variable "KKE_DYNAMODB_TABLE_NAME" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "KKE_SNS_TOPIC_NAME" {
  description = "The name of the SNS topic"
  type        = string
}

variable "KKE_SSM_PARAM_NAME" {
  description = "The name of the SSM Parameter"
  type        = string
}
```

3. Create main.tf file

```

# 1. DynamoDB Table (NoSQL Storage)
resource "aws_dynamodb_table" "app_table" {
  name         = var.KKE_DYNAMODB_TABLE_NAME
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ID"

  attribute {
    name = "ID"
    type = "S"
  }

  tags = {
    Environment = var.KKE_ENVIRONMENT
    Name        = var.KKE_DYNAMODB_TABLE_NAME
  }
}

# 2. SNS Topic (Messaging/Notifications)
resource "aws_sns_topic" "app_topic" {
  name = var.KKE_SNS_TOPIC_NAME

  tags = {
    Environment = var.KKE_ENVIRONMENT
  }
}

# 3. SSM Parameter (Secure Configuration)
resource "aws_ssm_parameter" "app_config" {
  name        = var.KKE_SSM_PARAM_NAME
  description = "Sensitive application configuration"
  type        = "SecureString"
  value       = "Nautilus-Secret-Config-2026" # Example sensitive value

  tags = {
    Environment = var.KKE_ENVIRONMENT
  }
}
```

4. Create outputs.tf file

```
output "kke_dynamodb_table_name" {
  value       = aws_dynamodb_table.app_table.name
  description = "The name of the DynamoDB table"
}

output "kke_sns_topic_arn" {
  value       = aws_sns_topic.app_topic.arn
  description = "The ARN of the SNS topic"
}

output "kke_ssm_parameter_name" {
  value       = aws_ssm_parameter.app_config.name
  description = "The name of the SSM parameter"
}
```

5. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
