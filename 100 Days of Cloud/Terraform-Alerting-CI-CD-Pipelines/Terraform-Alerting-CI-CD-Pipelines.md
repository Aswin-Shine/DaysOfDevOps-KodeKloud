The Nautilus DevOps team has been tasked to build a real-time data pipeline on AWS. The pipeline must collect streaming data, stage it in S3, monitor delivery failures, and alert via email. Your task is to implement this end-to-end using Terraform.

Pipeline Requirements:

1.) Kinesis Firehose:

Create a delivery stream named xfusion-firehose.
It should deliver data to an S3 bucket as a staging area.
2.) S3 Bucket:

Create a bucket named xfusion-staging-12758 (value to come from variables).
Set private ACL and allow Firehose to write objects into it.
3.) IAM Role and Policy:

Create a role xfusion-firehose-role and a policy xfusion-firehose-policy with least privilege to allow Firehose to write to the staging bucket.
4.) CloudWatch Alarm:

Create a cloudwatch Alarm named xfusion-firehose-failures.
Monitor the Firehose delivery failures metric (DeliveryToS3.Failures) and trigger when failures occur.
5.) SNS Topic:

Create a topic xfusion-alert-topic and link the CloudWatch alarm to it.
6.) SES Email Identity:

Create an SES email identity named xfusion@example.comand verify an SES email identity using an email address provided in the variables.
7.) SNS Subscription:

Subscribe the verified SES email identity to the SNS topic to receive notifications.
8.) Use main.tf file to define all AWS resources and to ensure a clean and modular setup.

9.) Use variables.tf file with the following variables:

KKE_STAGING_BUCKET_NAME: Name of the S3 bucket for staging data.
KKE_FIREHOSE_ROLE_NAME: Name of the IAM role for the Firehose delivery stream.
KKE_FIREHOSE_POLICY_NAME: Name of the IAM policy for the Firehose delivery stream.
KKE_FIREHOSE_NAME: Name of the Kinesis Firehose delivery stream.
KKE_SNS_TOPIC_NAME: Name of the SNS topic for alerts.
KKE_CLOUDWATCH_ALARM_NAME: Name of the CloudWatch alarm to monitor Firehose delivery failures.
KKE_ALERT_EMAIL: Email address to receive SNS alerts through SES.
10.) Use terraform.tfvarsto input the value of the variables used in the variables.tf.

11.) Use outputs.tf file to output the following:

kke_staging_bucket_name:name of the bucket used.
kke_firehose_name:name of the firehose delivery stream used.
kke_sns_topic_name:name of the sns topic used.
kke_cloudwatch_alarm_name:name of the cloudwatch used.
kke_ses_identity:name of the ses identity used.

Solution :

1. Create terraform.tfvars file

```
KKE_STAGING_BUCKET_NAME    = "xfusion-staging-12758"
KKE_FIREHOSE_ROLE_NAME     = "xfusion-firehose-role"
KKE_FIREHOSE_POLICY_NAME   = "xfusion-firehose-policy"
KKE_FIREHOSE_NAME          = "xfusion-firehose"
KKE_SNS_TOPIC_NAME         = "xfusion-alert-topic"
KKE_CLOUDWATCH_ALARM_NAME  = "xfusion-firehose-failures"
KKE_ALERT_EMAIL            = "xfusion@example.com"
```

2. Create variables.tf file

```
variable "KKE_STAGING_BUCKET_NAME" {
  type = string
}

variable "KKE_FIREHOSE_ROLE_NAME" {
  type = string
}

variable "KKE_FIREHOSE_POLICY_NAME" {
  type = string
}

variable "KKE_FIREHOSE_NAME" {
  type = string
}

variable "KKE_SNS_TOPIC_NAME" {
  type = string
}

variable "KKE_CLOUDWATCH_ALARM_NAME" {
  type = string
}

variable "KKE_ALERT_EMAIL" {
  type = string
}
```

3. Create main.tf file

```
# 1. S3 Staging Bucket
resource "aws_s3_bucket" "staging" {
  bucket = var.KKE_STAGING_BUCKET_NAME
}

resource "aws_s3_bucket_ownership_controls" "staging_oc" {
  bucket = aws_s3_bucket.staging.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "staging_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.staging_oc]
  bucket     = aws_s3_bucket.staging.id
  acl        = "private"
}

# 2. IAM Role and Policy for Firehose
resource "aws_iam_role" "firehose_role" {
  name = var.KKE_FIREHOSE_ROLE_NAME

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "firehose.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "firehose_policy" {
  name = var.KKE_FIREHOSE_POLICY_NAME
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:AbortMultipartUpload", "s3:GetBucketLocation", "s3:GetObject", "s3:ListBucket", "s3:ListBucketMultipartUploads", "s3:PutObject"]
        Effect   = "Allow"
        Resource = [aws_s3_bucket.staging.arn, "${aws_s3_bucket.staging.arn}/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_attach" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_policy.arn
}

# 3. Kinesis Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "xfusion_stream" {
  name        = var.KKE_FIREHOSE_NAME
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.staging.arn
  }
}

# 4. SNS Topic and Email Identity
resource "aws_sns_topic" "alert_topic" {
  name = var.KKE_SNS_TOPIC_NAME
}

resource "aws_ses_email_identity" "alert_email" {
  email = var.KKE_ALERT_EMAIL
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alert_topic.arn
  protocol  = "email"
  endpoint  = var.KKE_ALERT_EMAIL
}

# 5. CloudWatch Alarm for Failures
resource "aws_cloudwatch_metric_alarm" "firehose_failure_alarm" {
  alarm_name          = var.KKE_CLOUDWATCH_ALARM_NAME
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DeliveryToS3.Failures"
  namespace           = "AWS/Firehose"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "Triggered when Firehose fails to deliver data to S3"
  alarm_actions       = [aws_sns_topic.alert_topic.arn]

  dimensions = {
    DeliveryStreamName = aws_kinesis_firehose_delivery_stream.xfusion_stream.name
  }
}
```

4. Create outputs.tf file

```
output "kke_staging_bucket_name" {
  value = aws_s3_bucket.staging.bucket
}

output "kke_firehose_name" {
  value = aws_kinesis_firehose_delivery_stream.xfusion_stream.name
}

output "kke_sns_topic_name" {
  value = aws_sns_topic.alert_topic.name
}

output "kke_cloudwatch_alarm_name" {
  value = aws_cloudwatch_metric_alarm.firehose_failure_alarm.alarm_name
}

output "kke_ses_identity" {
  value = aws_ses_email_identity.alert_email.email
}
```

5. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
