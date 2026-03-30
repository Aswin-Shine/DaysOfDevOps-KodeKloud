The Nautilus DevOps team is expanding their AWS infrastructure and requires the setup of a private Virtual Private Cloud (VPC) along with a subnet. This VPC and subnet configuration will ensure that resources deployed within them remain isolated from external networks and can only communicate within the VPC. Additionally, the team needs to provision an EC2 instance under the newly created private VPC. This instance should be accessible only from within the VPC, allowing for secure communication and resource management within the AWS environment.

The Nautilus DevOps team is expanding their AWS infrastructure and requires the setup of a private Virtual Private Cloud (VPC) along with a subnet. This VPC and subnet configuration will ensure that resources deployed within them remain isolated from external networks and can only communicate within the VPC. Additionally, the team needs to provision an EC2 instance under the newly created private VPC. This instance should be accessible only from within the VPC, allowing for secure communication and resource management within the AWS environment.

1. Create a VPC named `datacenter-priv-vpc` with the CIDR block `10.0.0.0/16`.

2. Create a subnet named `datacenter-priv-subnet` inside the VPC with the CIDR block `10.0.1.0/24` and auto-assign IP option must not be enabled.

3. Create an EC2 instance named `datacenter-priv-ec2` inside the subnet and instance type must be `t2.micro`.

4. Ensure the security group of the EC2 instance allows access only from within the `VPC's CIDR block`.

5. Create the `main.tf` file (do not create a separate .tf file) to provision the VPC, subnet and EC2 instance.

6. Use `variables.tf` file with the following variable names:
   - `KKE_VPC_CIDR` for the VPC CIDR block.
   - `KKE_SUBNET_CIDR` for the subnet CIDR block.

7. Use the `outputs.tf` file with the following variable names:
   - `KKE_vpc_name` for the name of the VPC.
   - `KKE_subnet_name` for the name of the subnet.
   - `KKE_ec2_private` for the name of the EC2 instance.

Solution :

1. Create variables.tf file

```
variable "KKE_VPC_CIDR" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "KKE_SUBNET_CIDR" {
  description = "CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

variable "region" {
  default = "us-east-1"
}
```

2. Create main.tf file

```
# 1. Create the VPC
resource "aws_vpc" "datacenter_priv_vpc" {
  cidr_block = var.KKE_VPC_CIDR
  tags = {
    Name = "datacenter-priv-vpc"
  }
}

# 2. Create the Subnet
resource "aws_subnet" "datacenter_priv_subnet" {
  vpc_id                  = aws_vpc.datacenter_priv_vpc.id
  cidr_block              = var.KKE_SUBNET_CIDR
  map_public_ip_on_launch = false # Auto-assign IP disabled
  tags = {
    Name = "datacenter-priv-subnet"
  }
}

# 3. Create Security Group (Internal Access Only)
resource "aws_security_group" "internal_sg" {
  name        = "allow_internal_only"
  description = "Allow access only from within the VPC CIDR"
  vpc_id      = aws_vpc.datacenter_priv_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.KKE_VPC_CIDR]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. Create the EC2 Instance
resource "aws_instance" "datacenter_priv_ec2" {
  ami                    = "ami-0c55b159cbfafe1f0" # Replace with a valid AMI for your region
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.datacenter_priv_subnet.id
  vpc_security_group_ids = [aws_security_group.internal_sg.id]

  tags = {
    Name = "datacenter-priv-ec2"
  }
}
```

3. Create outputs.tf file

```
output "KKE_vpc_name" {
  value = aws_vpc.datacenter_priv_vpc.tags["Name"]
}

output "KKE_subnet_name" {
  value = aws_subnet.datacenter_priv_subnet.tags["Name"]
}

output "KKE_ec2_private" {
  value = aws_instance.datacenter_priv_ec2.tags["Name"]
}
```

4. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
