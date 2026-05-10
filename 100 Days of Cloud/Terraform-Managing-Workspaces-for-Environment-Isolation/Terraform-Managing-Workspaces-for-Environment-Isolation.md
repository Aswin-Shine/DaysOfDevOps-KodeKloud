The DevOps team is tasked with provisioning multiple API Gateway REST APIs and corresponding CloudWatch Log Groups using the following Terraform features:

Create two workspaces named dev and prod.

Create API Gateways named dev-nautilus-api-1 and prod-nautilus-api-2.

Create matching CloudWatch Log Groups named /aws/apigateway/dev-nautilus-api-1 and /aws/apigateway/prod-nautilus-api-2.

Use the count meta-argument to create multiple API Gateway REST APIs and matching log groups.

Leverage terraform workspaces to differentiate API Gateway names per environment.

Use local-exec provisioner to write a confirmation message to a log file once each resource is created.(e.g., Created API Gateway dev-nautilus-api-2 in workspace dev).

Create two different files apigateway.log and loggroups.log in /home/bob/terraform to log the creation of each resource in their respective files.

Use a list variable KKE_API_NAMES to define API names (e.g., ["nautilus-api-1", "nautilus-api-2"]).

Createmain.tf file (do not create a separate .tf file) to provision the api gateway with matching log groups in different workspaces.

Use variables.tf file with the following:

KKE_API_NAMES = Names of API Gateways to create.
Use terraform.tfvars file to input the names of the API Gateways.

Use outputs.tf file to output the following in the two different workspces ( devand prod).

kke_api_gateway_names= name of the api gateway created.
kke_log_group_names= name of the matching logroups created.

Solution :

1. Create terraform.tfvars file

```
KKE_API_NAMES = ["nautilus-api-1", "nautilus-api-2"]
```

2. Create variables.tf file

```
variable "KKE_API_NAMES" {
  type        = list(string)
  description = "List of API Gateway names"
}
```

3. Create main.tf file

```
# 1. API Gateway REST APIs
resource "aws_api_gateway_rest_api" "nautilus_api" {
  count = length(var.KKE_API_NAMES)

  # Logic: <workspace>-<api-name>
  name = "${terraform.workspace}-${var.KKE_API_NAMES[count.index]}"

  provisioner "local-exec" {
    command = "echo 'Created API Gateway ${self.name} in workspace ${terraform.workspace}' >> /home/bob/terraform/apigateway.log"
  }
}

# 2. CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "api_logs" {
  count = length(var.KKE_API_NAMES)

  # Matching the API Gateway name
  name  = "/aws/apigateway/${terraform.workspace}-${var.KKE_API_NAMES[count.index]}"

  provisioner "local-exec" {
    command = "echo 'Created Log Group ${self.name} in workspace ${terraform.workspace}' >> /home/bob/terraform/loggroups.log"
  }
}
```

4. Create outputs.tf file

```
output "kke_api_gateway_names" {
  value       = aws_api_gateway_rest_api.nautilus_api[*].name
  description = "The names of the API Gateways created in this workspace"
}

output "kke_log_group_names" {
  value       = aws_cloudwatch_log_group.api_logs[*].name
  description = "The names of the CloudWatch Log Groups created in this workspace"
}
```

5. Init & Create workspaces in terraform

```
terraform init
terraform workspace new dev
terraform worksapce new prod

```

6. Apply terraform files in dev workspace

```
terraform workspace select dev
terraform plan
terraform apply -auto-approve

```

7. Apply terraform files in prod workspace

```
terraform workspace select prod
terraform plan
terraform apply -auto-approve

```
