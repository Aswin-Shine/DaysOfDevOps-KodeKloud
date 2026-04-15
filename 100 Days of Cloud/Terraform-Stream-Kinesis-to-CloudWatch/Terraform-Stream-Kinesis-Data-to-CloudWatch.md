The monitoring team wants to improve observability into the streaming infrastructure. Your task is to implement a solution using Amazon Kinesis and CloudWatch. The team wants to ensure that if write throughput exceeds provisioned limits, an alert is triggered immediately.

As a member of the Nautilus DevOps Team, perform the following tasks using Terraform:

Create a Kinesis Data Stream: Name the stream xfusion-kinesis-stream with a shard count of 1.

Enable Monitoring: Enable shard-level metrics for the stream to track ingestion and throughput errors.

Create a CloudWatch Alarm: Name the alarm xfusion-kinesis-alarm and monitor the WriteProvisionedThroughputExceeded metric. The alarm should trigger if the metric exceeds a threshold of 1.

Ensure Alerting: Configure the CloudWatch alarm to detect write throughput issues exceeding provisioned limits.

Create the main.tf file (do not create a separate .tf file) to provision the Kinesis stream, CloudWatch alarm, and ensure alerting.

Create the outputs.tf file with the following variable names to output:

kke_kinesis_stream_name for the Kinesis stream name.

kke_kinesis_alarm_name for the CloudWatch alarm name.

Solution :

1. Create a main.tf file

```
# 1. Create the Kinesis Data Stream
resource "aws_kinesis_stream" "xfusion_kinesis_stream" {
  name             = "xfusion-kinesis-stream"
  shard_count      = 1
  retention_period = 24

  # Enable shard-level metrics for tracking ingestion and throughput errors
  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
    "WriteProvisionedThroughputExceeded"
  ]

  tags = {
    Name = "xfusion-kinesis-stream"
  }
}

# 2. Create the CloudWatch Alarm for Write Throughput
resource "aws_cloudwatch_metric_alarm" "xfusion_kinesis_alarm" {
  alarm_name          = "xfusion-kinesis-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "WriteProvisionedThroughputExceeded"
  namespace           = "AWS/Kinesis"
  period              = "60" # 1 minute
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Triggered if write throughput exceeded limit on the Kinesis stream"

  dimensions = {
    StreamName = aws_kinesis_stream.xfusion_kinesis_stream.name
  }
}
```

2. Create outputs.tf file

```
output "kke_kinesis_stream_name" {
  value       = aws_kinesis_stream.xfusion_kinesis_stream.name
  description = "The name of the Kinesis Data Stream"
}

output "kke_kinesis_alarm_name" {
  value       = aws_cloudwatch_metric_alarm.xfusion_kinesis_alarm.alarm_name
  description = "The name of the CloudWatch alarm"
}
```

3. Init/Apply all the terraform files.

```
terraform init
terraform plan
terraform apply -target=aws_kinesis_stream.xfusion_kinesis_stream -auto-approve
terraform apply -auto-approve
```
