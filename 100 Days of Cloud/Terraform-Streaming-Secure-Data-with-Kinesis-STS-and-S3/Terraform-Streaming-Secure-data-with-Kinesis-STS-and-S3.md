The Nautilus DevOps team is working on a secure cloud-native architecture using Terraform. As part of this, they need to provision streaming and storage infrastructure using only the allowed AWS services supported by LocalStack.

Your task as a DevOps engineer is to complete the following:

Create a Kinesis Stream: Provision a stream named xfusion-dev-stream with 1 shard and a 24-hour retention policy.

Create an S3 Bucket: Create a bucket named xfusion-dev-15092.

Use STS for Identity Check: Retrieve and print the current AWS Account ID using aws_caller_identity.

Ensure that the resources kinesis stream and s3 bucket are tagged with following:

Environment : dev (both the resources)

Purpose : Stream ingestion (Kinesis Stream)

Owner : xfusion (S3-bucket)

Add local-exec provisioners to output the creation messages and save them under the /home/bob/terraform directory. Specifically:

When creating the Kinesis stream, write the following message to a file named kinesis_creation.log:

"Kinesis Stream xfusion-dev-stream created"

When creating the S3 bucket, write the message to a file named s3_creation.log:

"S3 Bucket xfusion-dev-15092 created"

When retrieving the STS caller identity, write the following message to a file named account_identity.log:

"Logged in as account ID:<AWS account ID>"

Create main.tf file (do not create a separate .tf file) to provision the kinesis stream, s3-bucket and retrieve the Current AWS Account ID.

Use variables.tf file with the following variables:

KKE_ENVIRONMENT: dev

KKE_KINESIS_STREAM_NAME: Name of the Kinesis Stream (non-empty)

KKE_S3_BUCKET_NAME: Name of the S3 bucket.

Use terraform.tfvars to input the variable values.

Use outputs.tf to output the following:

kke_caller_identity_account_id: current AWS account ID.

kke_kinesis_stream_name: name of the stream created.

kke_s3_bucket_name: name of the bucket created.

Solution :

1. Create terraform.tfvars file

```
KKE_ENVIRONMENT         = "dev"
KKE_KINESIS_STREAM_NAME = "xfusion-dev-stream"
KKE_S3_BUCKET_NAME      = "xfusion-dev-15092"
```

2. Create variables.tf file

```
variable "KKE_ENVIRONMENT" {
  type    = string
  default = "dev"
}

variable "KKE_KINESIS_STREAM_NAME" {
  type        = string
  description = "Name of the Kinesis Stream"
  validation {
    condition     = length(var.KKE_KINESIS_STREAM_NAME) > 0
    error_message = "The Kinesis stream name must not be empty."
  }
}

variable "KKE_S3_BUCKET_NAME" {
  type = string
}
```

3. Create main.tf file

```
provider "aws" {
  region = "us-east-1"
}

# 1. Retrieve Current AWS Account ID using STS
data "aws_caller_identity" "current" {}

# 2. Provision Kinesis Stream
resource "aws_kinesis_stream" "xfusion_stream" {
  name             = var.KKE_KINESIS_STREAM_NAME
  shard_count      = 1
  retention_period = 24

  tags = {
    Environment = var.KKE_ENVIRONMENT
    Purpose     = "Stream ingestion"
  }
}

# 3. Provision S3 Bucket
resource "aws_s3_bucket" "xfusion_bucket" {
  bucket = var.KKE_S3_BUCKET_NAME

  tags = {
    Environment = var.KKE_ENVIRONMENT
    Owner       = "xfusion"
  }
}

# 4. Local-exec Provisioners for Logging
resource "null_resource" "logging" {
  # Trigger when resources are created
  triggers = {
    kinesis_id = aws_kinesis_stream.xfusion_stream.id
    s3_id      = aws_s3_bucket.xfusion_bucket.id
    account_id = data.aws_caller_identity.current.account_id
  }

  provisioner "local-exec" {
    command = "echo 'Kinesis Stream ${var.KKE_KINESIS_STREAM_NAME} created' > /home/bob/terraform/kinesis_creation.log"
  }

  provisioner "local-exec" {
    command = "echo 'S3 Bucket ${var.KKE_S3_BUCKET_NAME} created' > /home/bob/terraform/s3_creation.log"
  }

  provisioner "local-exec" {
    command = "echo 'Logged in as account ID:${data.aws_caller_identity.current.account_id}' > /home/bob/terraform/account_identity.log"
  }
}
```

4. Create outputs.tf file

```
output "kke_caller_identity_account_id" {
  value       = data.aws_caller_identity.current.account_id
  description = "The current AWS account ID"
}

output "kke_kinesis_stream_name" {
  value       = aws_kinesis_stream.xfusion_stream.name
  description = "The name of the Kinesis stream"
}

output "kke_s3_bucket_name" {
  value       = aws_s3_bucket.xfusion_bucket.id
  description = "The name of the S3 bucket"
}
```

5. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

# In my case there was error while completing the task, so the workthourgh of the error was
terraform refresh
terraform plan
terraform apply -auto-approve
```

6. To verify the task

```
cd /home/bob/terraform
ls
```
