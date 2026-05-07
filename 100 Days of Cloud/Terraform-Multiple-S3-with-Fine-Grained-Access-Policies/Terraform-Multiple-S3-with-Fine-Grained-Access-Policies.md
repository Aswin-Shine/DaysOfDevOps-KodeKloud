The Nautilus DevOps team needs to set up three S3 buckets for different environments with backup and policy configurations. Follow the steps below:

Create three S3 buckets using for_each for environments: Dev, Staging, and Prod.

Name the buckets using the following naming convention:

devops-dev-bucket-30379
devops-staging-bucket-30379
devops-prod-bucket-30379
Add the following tags to each bucket with the corresponding values:

a.) For devops-dev-bucket-30379:

Name = devops-dev-bucket-30379
Environment = Dev
Owner = Alice
b.) For devops-staging-bucket-30379:

Name = devops-staging-bucket-30379
Environment = Staging
Owner = Bob
c.) For devops-prod-bucket-30379:

Environment = Prod
Owner = Carol
For the staging and prod buckets, set Backup = true and add a lifecycle rule with ID MoveToGlacier to transition objects to Glacier after 30 days.

Use the lifecycle block with ignore_changes to protect the tags.

Create a bucket policy that allows public read access to all objects in the bucket.

Use depends_on to ensure the policy is only applied after the bucket has been created.

Implement the entire configuration in a single main.tf file (do not create a separate .tf file) to provision multiple S3 buckets with the specified configurations.

Use variables.tf with the following variable:

KKE_ENV_TAGS. KKE_ENV_TAGS is a map that holds environment-specific metadata such as bucket name, owner, and backup flag.
Use outputs.tf file to output the following:

kke_bucket_names: output the names of the bucket created.

Solution :

1. Create variables.tf file

```
variable "KKE_ENV_TAGS" {
  type = map(object({
    bucket_name = string
    owner       = string
    backup      = bool
  }))
  default = {
    Dev = {
      bucket_name = "devops-dev-bucket-30379"
      owner       = "Alice"
      backup      = false
    }
    Staging = {
      bucket_name = "devops-staging-bucket-30379"
      owner       = "Bob"
      backup      = true
    }
    Prod = {
      bucket_name = "devops-prod-bucket-30379"
      owner       = "Carol"
      backup      = true
    }
  }
}
```

2. Create main.tf file

```
provider "aws" {
  region = "us-east-1"
}

# 1. Create S3 Buckets using for_each
resource "aws_s3_bucket" "env_buckets" {
  for_each = var.KKE_ENV_TAGS
  bucket   = each.value.bucket_name

  tags = {
    Name        = each.value.bucket_name
    Environment = each.key
    Owner       = each.value.owner
    Backup      = each.value.backup ? "true" : "false"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

# 2. Lifecycle Rule for Staging and Prod (Move to Glacier)
resource "aws_s3_bucket_lifecycle_configuration" "glacier_transition" {
  # Only apply to buckets where backup is true
  for_each = { for k, v in var.KKE_ENV_TAGS : k => v if v.backup }
  bucket   = aws_s3_bucket.env_buckets[each.key].id

  rule {
    id     = "MoveToGlacier"
    status = "Enabled"

    filter{
      prefix = ""
    }

    transition {
      days          = 30
      storage_class = "GLACIER"
    }
  }
}

# 3. Public Read Access Policy
resource "aws_s3_bucket_policy" "public_read" {
  for_each = aws_s3_bucket.env_buckets
  bucket   = each.value.id

  # Ensure the bucket exists before applying policy
  depends_on = [aws_s3_bucket.env_buckets]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${each.value.arn}/*"
      },
    ]
  })
}

# Note: Modern S3 buckets require disabling Block Public Access to allow public policies
resource "aws_s3_bucket_public_access_block" "allow_public" {
  for_each = aws_s3_bucket.env_buckets
  bucket   = each.value.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```

3. Create outputs.tf file

```
output "kke_bucket_names" {
  value       = [for b in aws_s3_bucket.env_buckets : b.bucket]
  description = "The names of the buckets created for each environment"
}
```

4. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve
```
