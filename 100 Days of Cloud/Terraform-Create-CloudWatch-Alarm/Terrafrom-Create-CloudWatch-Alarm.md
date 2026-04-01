The Nautilus DevOps team has been tasked with setting up an EC2 instance for their application. To ensure the application performs optimally, they also need to create a CloudWatch alarm to monitor the instance's CPU utilization. The alarm should trigger if the CPU utilization exceeds 90% for one consecutive 5-minute period. To send notifications, use the SNS topic named devops-sns-topic, which is already created.

1. Launch EC2 Instance: Create an EC2 instance named devops-ec2 using any appropriate Ubuntu AMI (you can use AMI ami-0c02fb55956c7d316).

2. Create CloudWatch Alarm: Create a CloudWatch alarm named devops-alarm with the following specifications:

Statistic: Average
Metric: CPU Utilization
Threshold: >= 90% for 1 consecutive 5-minute period
Alarm Actions: Send a notification to the devops-sns-topic SNS topic.

3. Update the main.tf file (do not create a separate .tf file) to create a EC2 Instance and CloudWatch Alarm.

4.Create an outputs.tf file to output the following values:

KKE_instance_name for the EC2 instance name.
KKE_alarm_name for the CloudWatch alarm name.

Solution :

1. Edit the main.tf file (EC2 & CloudWatch Creation)

```
# 1. Launch the EC2 Instance
resource "aws_instance" "devops_ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  tags = {
    Name = "devops-ec2"
  }
}

# 2. Create the CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "devops_alarm" {
  alarm_name          = "devops-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300" # 5 minutes in seconds
  statistic           = "Average"
  threshold           = "90"
  alarm_description   = "This alarm monitors EC2 CPU utilization"

  # Link the alarm to the specific instance
  dimensions = {
    InstanceId = aws_instance.devops_ec2.id
  }

  # Action to trigger SNS notification
  alarm_actions = [data.aws_sns_topic.devops_sns.arn]
}
```

2. Create output.tf file

```
output "KKE_instance_name" {
  value       = aws_instance.devops_ec2.tags["Name"]
  description = "The name of the EC2 instance"
}

output "KKE_alarm_name" {
  value       = aws_cloudwatch_metric_alarm.devops_alarm.alarm_name
  description = "The name of the CloudWatch alarm"
}

```

3. Init/Apply the terraform files.

```
terraform init
terraform plan
terraform apply -auto-approve
```
