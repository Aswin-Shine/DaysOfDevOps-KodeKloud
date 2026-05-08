The Nautilus DevOps team has been tasked with creating an internal information portal for public access. As part of this project, they need to host a static website on AWS using an S3 bucket. The S3 bucket must be configured for public access to allow external users to access the static website directly via the S3 website URL.

Your task is to create a Terraform module named s3-static-site to handle the creation and configuration of the S3 bucket. For uploading the index.html file, you may use either Terraform or the AWS CLI.

Task Requirements:

The module directory /home/bob/terraform/modules/s3-static-site/ is already created, configure the module to perform the following tasks:

Create an S3 bucket named nautilus-web-29483.

Configure the S3 bucket for static website hosting with index.html as the index document.

Allow public access to the bucket by attaching the appropriate bucket policy.

Within the module, use a variables.tf file that must define the following variables: bucket_name and index_document. These values should not be hardcoded directly into resource definitions. You may add other variables if needed to avoid hardcoding. Use these variables in main.tf for configuring the bucket.

Within the module use outputs.tf file to output the following:

website_url: S3 static website url
Your S3 website url should look something like the following, aws:4566 refers to the mock AWS endpoint configured in your environment (e.g., using LocalStack):

http://aws:4566/<bucketname>/index.html
The S3 bucket must be tagged with the key Project and the value StaticWeb.

In the root main.tf, call the s3-static-site module using the required input variables (bucket_name, index_document).

Upload the index.html file from /home/bob/terraform directory to the S3 bucket. This can be done using either the AWS CLI or Terraform (aws_s3_object).


Solution :

1. Create variables.tf file in module folder

```
variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket"
}

variable "index_document" {
  type        = string
  description = "The index document for the static website"
  default     = "index.html"
}

```

2. Create main.tf file in the module folder

```
# 1. Create the S3 Bucket
resource "aws_s3_bucket" "static_site" {
  bucket = var.bucket_name

  tags = {
    Project = "StaticWeb"
  }
}

# 2. Configure Static Website Hosting
resource "aws_s3_bucket_website_configuration" "config" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = var.index_document
  }
}

# 3. Disable Block Public Access (Required for public policies)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 4. Attach Public Read Policy
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.static_site.id
  depends_on = [aws_s3_bucket_public_access_block.public_access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_site.arn}/*"
      }
    ]
  })
}

```

3. Create outputs.tf file in the module folder

```
output "website_url" {
  # Format specifically for the mock environment requirements
  value = "http://aws:4566/${aws_s3_bucket.static_site.bucket}/${var.index_document}"
}

output "bucket_id" {
  value = aws_s3_bucket.static_site.id
}

```

3. Create main.tf file

```
# Call the S3 Static Site Module
module "s3_static_site" {
  source         = "./modules/s3-static-site"
  bucket_name    = "nautilus-web-29483"
  index_document = "index.html"
}

# Upload index.html to the bucket
resource "aws_s3_object" "index" {
  bucket       = module.s3_static_site.bucket_id
  key          = "index.html"
  source       = "/home/bob/terraform/index.html"
  content_type = "text/html"
}

```

5. Create outputs.tf file in the module folder

```
output "website_url" {
  value = module.s3_static_site.website_url
}

```

6. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
