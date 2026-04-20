The Nautilus DevOps team is implementing lifecycle policies to manage object storage efficiently in AWS. They want to create an S3 bucket with a specific lifecycle rule that transitions objects to infrequent access (IA) storage after 30 days and deletes them after 365 days.

Create an S3 bucket named xfusion-lifecycle-28471.

Enable the S3 Versioning on the bucket.

Add a lifecycle rule named xfusion-lifecycle-rule with:

Transition to STANDARD_IA storage class after 30 days.
Expiration of objects after 365 days.
Use the main.tf file (do not create a separate .tf file) to provision the S3 bucket.

Use the variable name KKE_bucket_name in the outputs.tf file to output the created bucket name.

Solution :

1. Create main.tf file

```
# 1. Create the S3 Bucket
resource "aws_s3_bucket" "xfusion_bucket" {
  bucket = "xfusion-lifecycle-28471"

  tags = {
    Name        = "xfusion-lifecycle-28471"
    Environment = "DevOps"
  }
}

# 2. Enable S3 Versioning
resource "aws_s3_bucket_versioning" "xfusion_versioning" {
  bucket = aws_s3_bucket.xfusion_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Add the Lifecycle Rule
resource "aws_s3_bucket_lifecycle_configuration" "xfusion_rule" {
  bucket = aws_s3_bucket.xfusion_bucket.id

  rule {
    id     = "xfusion-lifecycle-rule"
    status = "Enabled"

    # Transition to Standard Infrequent Access after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Add filter bracket to selected all the objects in the bucket for newer versions
    filter {
      prefix = ""
    }

    # Permanent deletion after 365 days
    expiration {
      days = 365
    }
  }
}

```

2. Create outputs.tf file

```
output "KKE_bucket_name" {
  value       = aws_s3_bucket.xfusion_bucket.id
  description = "The name of the created S3 bucket"
}

```

3. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
