To ensure secure and accidental-deletion-proof storage, the DevOps team must configure an S3 bucket using Terraform with strict lifecycle protections. The goal is to create a bucket that is dynamically named and protected from being destroyed by mistake. Please complete the following tasks:

Create an S3 bucket named xfusion-s3-9286.

Apply the prevent_destroy lifecycle rule to protect the bucket.

Create the main.tf file (do not create a separate .tf file) to provision a s3 bucket with prevent_destroy lifecycle rule.

Use the variables.tf file with the following:

KKE_BUCKET_NAME: name of the bucket.
Use the terraform.tfvars file to input the name of the bucket.

Use the outputs.tffile with the following:

s3_bucket_name: name of the created bucket.

Solution :

1. Create terraform.tfvars file

```
KKE_BUCKET_NAME = "xfusion-s3-9286"
```

2. Create variables.tf file

```
variable "KKE_BUCKET_NAME" {
  description = "The name of the S3 bucket"
  type        = string
}
```

2. Create main.tf file

```
resource "aws_s3_bucket" "xfusion_bucket" {
  bucket = var.KKE_BUCKET_NAME

  # Lifecycle rule to prevent accidental deletion
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = var.KKE_BUCKET_NAME
    Environment = "Production"
  }
}
```

3. Create the outputs.tf file

```
output "s3_bucket_name" {
  value       = aws_s3_bucket.xfusion_bucket.bucket
  description = "The name of the created S3 bucket"
}
```

4. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve
```
