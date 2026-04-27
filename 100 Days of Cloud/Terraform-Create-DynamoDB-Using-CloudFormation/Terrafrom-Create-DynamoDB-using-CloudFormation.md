The Nautilus DevOps team wants to automate infrastructure provisioning using CloudFormation. As part of the stack setup, they need to create a DynamoDB table.

Create a CloudFormation stack named datacenter-dynamodb-stack.

The stack must create a DynamoDB table named datacenter-cf-dynamodb-table.

Use the main.tf file (do not create a separate .tf file) to provision a CloudFormation stack and DynamoDB table. Make sure to add a lifecycle block in main.tf to ignore changes to the parameters attribute.

Use the variables.tf file with the following variable names:

KKE_DYNAMODB_TABLE_NAME: Dynamodb table name.
The locals.tf file is already provided and includes the following:

cf_template_body: A local variable that stores the CloudFormation template body.
Use the outputs.tf file to output the following:

KKE_stack_name: CloudFormation stack name

Solution :

1. Create variables.tf file

```
variable "KKE_DYNAMODB_TABLE_NAME" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "datacenter-cf-dynamodb-table"
}
```

2. Create main.tf file

```
resource "aws_cloudformation_stack" "dynamodb_stack" {
  name          = "datacenter-dynamodb-stack"
  template_body = local.cf_template_body

  # Passing the table name as a parameter to the CF template
  parameters = {
    TableName = var.KKE_DYNAMODB_TABLE_NAME
  }

  # Ignore changes to parameters as requested
  lifecycle {
    ignore_changes = [
      parameters,
    ]
  }

  tags = {
    Name = "datacenter-dynamodb-stack"
  }
}
```

3. Create outputs.tf file

```
output "KKE_stack_name" {
  value       = aws_cloudformation_stack.dynamodb_stack.name
  description = "The name of the CloudFormation stack"
}
```

4. Init/Apply terraform files

```
terraform init
terraform plan
terraform apply -auto-approve
```
