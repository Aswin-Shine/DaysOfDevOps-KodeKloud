To test resilience and recreation behavior in Terraform, the DevOps team needs to demonstrate the use of the -replace option to forcefully recreate an EC2 instance without changing its configuration. Please complete the following tasks:

Use the Terraform CLI -replace option to destroy and recreate the EC2 instance xfusion-ec2, even though the configuration remains unchanged.

Ensure that the instance is recreated successfully.

Solution :

1. Write this in the terminal

```
terraform apply -auto-approve -replace = "aws.instance.web_server"
```
