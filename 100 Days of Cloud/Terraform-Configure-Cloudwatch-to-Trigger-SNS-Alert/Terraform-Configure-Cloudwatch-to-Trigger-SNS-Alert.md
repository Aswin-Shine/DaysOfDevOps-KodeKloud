The Nautilus DevOps team is expanding their AWS infrastructure and requires the setup of a CloudWatch alarm and SNS integration for monitoring EC2 instances. The team needs to configure an SNS topic for CloudWatch to publish notifications when an EC2 instance’s CPU utilization exceeds 80%. The alarm should trigger whenever the CPU utilization is greater than 80% and notify the SNS topic to alert the team.

Create an SNS topic named datacenter-sns-topic.

Create a CloudWatch alarm named datacenter-cpu-alarm to monitor EC2 CPU utilization with the following conditions:

Metric: CPUUtilization
Threshold: 80%
Actions enabled
Alarm actions should be triggered to the SNS topic.
Ensure that the SNS topic receives notifications from the CloudWatch alarm when it is triggered.

Update the main.tf file (do not create a different .tf file) to create SNS Topic and Cloudwatch Alarm.

Create an outputs.tf file to output the following values:

KKE_sns_topic_name for the SNS topic name.
KKE_cloudwatch_alarm_name for the CloudWatch alarm name.

Solution :

1. Update the main.tf file

```
# 1. Create the SNS Topic for alerts
resource "aws_sns_topic" "datacenter_sns" {
  name = "datacenter-sns-topic"
}

# 2. Create the CloudWatch Metric Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "datacenter-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120" # 2 minutes
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"

  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.datacenter_sns.arn]
}
```

2. Create outputs.tf file

```
output "KKE_sns_topic_name" {
  value       = aws_sns_topic.datacenter_sns.name
  description = "The name of the SNS topic"
}

output "KKE_cloudwatch_alarm_name" {
  value       = aws_cloudwatch_metric_alarm.cpu_alarm.alarm_name
  description = "The name of the CloudWatch alarm"
}
```

3. Init/Apply the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve
```
