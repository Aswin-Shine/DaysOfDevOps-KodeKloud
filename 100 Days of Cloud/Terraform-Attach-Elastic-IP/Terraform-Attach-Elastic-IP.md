The Nautilus DevOps Team has received a new request from the Development Team to set up a new EC2 instance. This instance will be used to host a new application that requires a stable IP address. To ensure that the instance has a consistent public IP, an Elastic IP address needs to be associated with it. This setup will help the Development Team to have a reliable and consistent access point for their application.

Create an EC2 instance named datacenter-ec2 using any Linux AMI like Ubuntu.

Instance type must be t2.micro and associate an Elastic IP address named datacenter-eipwith this instance.

Use the main.tf file (do not create a separate .tf file) to provision the EC2-Instance and Elastic IP.

Use the outputs.tf file and output the instance name using variable KKE_instance_name and the Elastic IP using variable KKE_eip.

Solution :

1. Create main.tf file

```
# 1. Create the EC2 Instance
resource "aws_instance" "datacenter_ec2" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"

  tags = {
    Name = "datacenter-ec2"
  }
}

# 2. Allocate and Associate Elastic IP
resource "aws_eip" "datacenter_eip" {
  instance = aws_instance.datacenter_ec2.id
  domain   = "vpc"

  tags = {
    Name = "datacenter-eip"
  }
}
```

2. Create outputs.tf file

```
output "KKE_instance_name" {
  value       = aws_instance.datacenter_ec2.tags["Name"]
  description = "The name of the EC2 instance"
}

output "KKE_eip" {
  value       = aws_eip.datacenter_eip.public_ip
  description = "The Elastic IP address associated with the instance"
}
```

3. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
