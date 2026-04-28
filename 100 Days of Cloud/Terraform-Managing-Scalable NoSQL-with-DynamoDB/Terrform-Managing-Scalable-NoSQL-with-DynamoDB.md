The Nautilus DevOps team is developing a simple 'To-Do' application using DynamoDB to store and manage tasks efficiently. The team needs to create a DynamoDB table to hold tasks, each identified by a unique task ID. Each task will have a description and a status, which indicates the progress of the task (eg., 'completed' or 'in-progress').

Your task is to:

Create a DynamoDB table named xfusion-tasks with a primary key called taskId (string).

Insert the following tasks into the table:
Task 1: taskId: 1, description: Learn DynamoDB, status: completed
Task 2: taskId: 2, description: Build To-Do App, status: in-progress

Verify that Task 1 has a status of completed and Task 2 has a status of in-progress.

Create main.tf(do not create a separate .tf file) to provision a dynamo_db table and insert tasks.

Create a variables.tf file with the following:

KKE_TABLE_NAME: name of the dynamo_db table.
Use terraform.tfvars file to input the name of the dynamo_db table.

Use outputs.tf file for the following:

kke_dynamodb_table_name: name of the dynamo_db table created.

Solution :

1. Create terraform.tfvars file.

```
KKE_TABLE_NAME = "xfusion-tasks"
```

2. Create variables.tf file

```
variable "KKE_TABLE_NAME" {
  description = "The name of the DynamoDB table"
  type        = string
}
```

3. Create main.tf file

```
# 1. Create the DynamoDB Table
resource "aws_dynamodb_table" "todo_table" {
  name         = var.KKE_TABLE_NAME
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "taskId"

  attribute {
    name = "taskId"
    type = "S" # String type as requested
  }

  tags = {
    Application = "To-Do-App"
    Environment = "Dev"
  }
}

# 2. Insert Task 1
resource "aws_dynamodb_table_item" "task_1" {
  table_name = aws_dynamodb_table.todo_table.name
  hash_key   = aws_dynamodb_table.todo_table.hash_key

  item = jsonencode({
    "taskId"      = {"S": "1"},
    "description" = {"S": "Learn DynamoDB"},
    "status"      = {"S": "completed"}
  })
}

# 3. Insert Task 2
resource "aws_dynamodb_table_item" "task_2" {
  table_name = aws_dynamodb_table.todo_table.name
  hash_key   = aws_dynamodb_table.todo_table.hash_key

  item = jsonencode({
    "taskId"      = {"S": "2"},
    "description" = {"S": "Build To-Do App"},
    "status"      = {"S": "in-progress"}
  })
}
```

4. Create outputs.tf file

```
output "kke_dynamodb_table_name" {
  value       = aws_dynamodb_table.todo_table.name
  description = "The name of the created DynamoDB table"
}
```

5. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve
```

6. To verify the task use this command

```
aws dynamodb scan --table-name xfusion-tasks
```
