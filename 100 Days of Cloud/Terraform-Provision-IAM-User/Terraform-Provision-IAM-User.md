The Nautilus DevOps team is experimenting with Terraform provisioners. Your task is to create an IAM user and use a local-exec provisioner to log a confirmation message.

Create an IAM user named iamuser_mark.

Use a local-exec provisioner with the IAM user resource to log the message KKE iamuser_mark has been created successfully! to a file called KKE_user_created.log under home/bob/terraform.

Create the main.tf file (do not create a separate .tf file) to provision an IAM user.

Use variables.tf file with the following:

KKE_USER_NAME: name of the IAM user.
Use terraform.tfvars to input the name of the IAM user.

Use outputs.tf file with the following:

kke_iam_user_name: name of the IAM user.

Solution :

1. Create terraform.tfvars file

```
KKE_USER_NAME = "iamuser_mark"
```

2. Create variables.tf file

```
variable "KKE_USER_NAME" {
  description = "The name of the IAM user"
  type        = string
}
```

3. Create main.tf file

```
# 1. Create the IAM User
resource "aws_iam_user" "mark_user" {
  name = var.KKE_USER_NAME

  # 2. Local-exec provisioner to log the creation message
  provisioner "local-exec" {
    command = "echo 'KKE ${var.KKE_USER_NAME} has been created successfully!' >> /home/bob/terraform/KKE_user_created.log"
  }
}
```

4. Create outputs.tf file

```
output "kke_iam_user_name" {
  value       = aws_iam_user.mark_user.name
  description = "The name of the created IAM user"
}
```

5. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```

6. To verify the task check

```
cd home/bob/terraform
ls
cat KKE_user_created.log
```
