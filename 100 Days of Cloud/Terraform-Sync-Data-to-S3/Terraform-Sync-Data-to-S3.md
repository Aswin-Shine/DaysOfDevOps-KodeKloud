As part of a data migration project, the team lead has tasked the team with migrating data from an existing S3 bucket to a new S3 bucket. The existing bucket contains a substantial amount of data that must be accurately transferred to the new bucket. The team is responsible for creating the new S3 bucket using Terraform and ensuring that all data from the existing bucket is copied or synced to the new bucket completely and accurately. It is imperative to perform thorough verification steps to confirm that all data has been successfully transferred to the new bucket without any loss or corruption.

As a member of the Nautilus DevOps Team, your task is to perform the following using Terraform:

Create a New Private S3 Bucket: Name the bucket devops-sync-31147 and store this bucket name in a variable named KKE_BUCKET.

Data Migration: Migrate all data from the existing devops-s3-22622 bucket to the new devops-sync-31147 bucket.

Ensure Data Consistency: Ensure that both buckets contain the same data after migration.

Update the main.tf file (do not create a separate .tf file) to provision a new private S3 bucket and migrate the data.

Use the variables.tf file with the following variable:

KKE_BUCKET: The name for the new bucket created.
Use the outputs.tf file with the following outputs:

new_kke_bucket_name: The name of the new bucket created.

new_kke_bucket_acl: The ACL of the new bucket created.

Solution :

1. Create variables.tf file

```
variable "KKE_BUCKET" {
  description = "The name of the new S3 bucket"
  type        = string
  default     = "devops-sync-31147"
}
```

2. Update main.tf file

```
# 1. Create the new S3 Bucket
resource "aws_s3_bucket" "new_bucket" {
  bucket = var.KKE_BUCKET

  tags = {
    Name        = var.KKE_BUCKET
    Environment = "DevOps"
  }
}

# 2. Set Ownership Controls (Required for ACLs)
resource "aws_s3_bucket_ownership_controls" "new_bucket_oc" {
  bucket = aws_s3_bucket.new_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# 3. Set the bucket to Private
resource "aws_s3_bucket_acl" "new_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.new_bucket_oc]

  bucket = aws_s3_bucket.new_bucket.id
  acl    = "private"
}

# 4. Data Migration Logic
# This triggers a local AWS CLI command to sync data from the old bucket to the new one
resource "null_resource" "bucket_migration" {
  depends_on = [aws_s3_bucket.new_bucket]

  provisioner "local-exec" {
    command = "aws s3 sync s3://devops-s3-22622 s3://${aws_s3_bucket.new_bucket.id}"
  }

  # This ensures the migration re-runs if the bucket ID changes
  triggers = {
    new_bucket_id = aws_s3_bucket.new_bucket.id
  }
}
```

3. Create the outputs.tf file

```
output "new_kke_bucket_name" {
  value       = aws_s3_bucket.new_bucket.id
  description = "The name of the new bucket created"
}

output "new_kke_bucket_acl" {
  value       = aws_s3_bucket_acl.new_bucket_acl.acl
  description = "The ACL of the new bucket created"
}
```

4. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
