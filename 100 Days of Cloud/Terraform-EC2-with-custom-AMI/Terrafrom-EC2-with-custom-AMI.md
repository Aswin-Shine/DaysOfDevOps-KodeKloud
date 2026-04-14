The Nautilus DevOps team needs to create an AMI from an existing EC2 instance for backup and scaling purposes. The following steps are required:

They have an existing EC2 instance named nautilus-ec2.

They need to create an AMI named nautilus-ec2-ami from this instance.

Additionally, they need to launch a new EC2 instance named nautilus-ec2-new using this AMI.

Update the main.tf file (do not create a different or separate.tf file) to provision an AMI and then launch an EC2 Instance from that AMI.

Create an outputs.tf file to output the following values:

KKE_ami_id for the AMI ID you created.
KKE_new_instance_id for the EC2 instance ID you created.

Solution :

1. Edit main.tf file

```
# 1. Create an AMI from the existing instance
resource "aws_ami_from_instance" "nautilus_ec2_ami" {
  name               = "nautilus-ec2-ami"
  source_instance_id = data.aws_instance.ec2.id
}

# 2. Launch a new EC2 instance using the newly created AMI
resource "aws_instance" "nautilus_ec2_new" {
  ami           = aws_ami_from_instance.nautilus_ec2_ami.id
  instance_type = "t2.micro"

  tags = {
    Name = "nautilus-ec2-new"
  }
}
```

2. Create outputs.tf file

```
output "KKE_ami_id" {
  value       = aws_ami_from_instance.nautilus_ec2_ami.id
  description = "The ID of the created AMI"
}

output "KKE_new_instance_id" {
  value       = aws_instance.nautilus_ec2_new.id
  description = "The ID of the new EC2 instance launched from the AMI"
}
```

3. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
