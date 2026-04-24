To enable secure inter-service communication, the DevOps team needs to configure access to an SNS topic using IAM roles and policies. The objective is to allow EC2 instances to publish messages to the topic using proper permissions and role assumptions. Please complete the following tasks:

Create an SNS topic named xfusion-sns-topic.

Create an IAM role named xfusion-sns-role with EC2 as the trusted entity.

Attach an IAM policy named xfusion-sns-policy that grants permission to publish messages to the SNS topic.

Use the main.tf file (do not create a separate .tf file) to provision the sns-topic, role and policy.

Create the locals.tfwith the following names:

KKE_SNS_TOPIC_NAME:name of the sns topic created.
KKE_ROLE_NAME: name of the role created.
KKE_POLICY_NAME: name of the policy created.
Create the outputs.tf file to the output the following:

The name of the SNS topic using the output variable kke_sns_topic_name.

The name of the role using the output variable kke_role_name.

The name of the policy using the output variable kke_policy_name.

Solution :

1. Create locals.tf file

```
locals {
  KKE_SNS_TOPIC_NAME = "xfusion-sns-topic"
  KKE_ROLE_NAME      = "xfusion-sns-role"
  KKE_POLICY_NAME    = "xfusion-sns-policy"
}
```

2. Create main.tf file

```
# 1. Create the SNS Topic
resource "aws_sns_topic" "xfusion_sns" {
  name = local.KKE_SNS_TOPIC_NAME
}

# 2. Create the IAM Role with EC2 Trust Relationship
resource "aws_iam_role" "xfusion_role" {
  name = local.KKE_ROLE_NAME

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

# 3. Create the IAM Policy for SNS Publishing
resource "aws_iam_policy" "xfusion_policy" {
  name = local.KKE_POLICY_NAME

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sns:Publish"
        Effect   = "Allow"
        Resource = aws_sns_topic.xfusion_sns.arn
      }
    ]
  })
}

# 4. Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "sns_attach" {
  role       = aws_iam_role.xfusion_role.name
  policy_arn = aws_iam_policy.xfusion_policy.arn
}
```

3. Create outputs.tf file

```
output "kke_sns_topic_name" {
  value       = aws_sns_topic.xfusion_sns.name
  description = "The name of the SNS topic"
}

output "kke_role_name" {
  value       = aws_iam_role.xfusion_role.name
  description = "The name of the IAM role"
}

output "kke_policy_name" {
  value       = aws_iam_policy.xfusion_policy.name
  description = "The name of the IAM policy"
}
```

4. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
