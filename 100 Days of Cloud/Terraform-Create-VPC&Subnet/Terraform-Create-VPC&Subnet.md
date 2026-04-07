To ensure proper resource provisioning order, the DevOps team wants to explicitly define the dependency between an AWS VPC and a Subnet. The objective is to create a VPC and then a Subnet that explicitly depends on it using Terraform's depends_on argument.

Please complete the following tasks:

1. Create a VPC named nautilus-vpc.

2. Create a Subnet named nautilus-subnet.

3. Ensure the Subnet uses the depends_on argument to explicitly depend on the VPC resource.

4. Create the main.tf file (do not create a separate .tf file) to provision a VPC and Subnet.

5. Use variables.tf, define the following variables:

KKE_VPC_NAME for the VPC name.
KKE_SUBNET_NAME for the Subnet name.

6. Use terraform.tfvars to input the names of the VPC and subnet.

7. In outputs.tf, output the following:

kke_vpc_name: The name of the VPC.
kke_subnet_name: The name of the Subnet.

Solution :

1. Create terraform.tfvars file

```
KKE_VPC_NAME    = "nautilus-vpc"
KKE_SUBNET_NAME = "nautilus-subnet"
```

2. Create variables.tf file

```
variable "KKE_VPC_NAME" {
  description = "The name of the VPC"
  type        = string
}

variable "KKE_SUBNET_NAME" {
  description = "The name of the Subnet"
  type        = string
}
```

3. Create main.tf file

```
# 1. Create the VPC
resource "aws_vpc" "nautilus_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.KKE_VPC_NAME
  }
}

# 2. Create the Subnet with explicit dependency
resource "aws_subnet" "nautilus_subnet" {
  vpc_id     = aws_vpc.nautilus_vpc.id
  cidr_block = "10.0.1.0/24"

  # Explicitly depend on the VPC resource
  depends_on = [aws_vpc.nautilus_vpc]

  tags = {
    Name = var.KKE_SUBNET_NAME
  }
}
```

4. Create outputs.tf file

```
output "kke_vpc_name" {
  value       = aws_vpc.nautilus_vpc.tags["Name"]
  description = "The name of the VPC"
}

output "kke_subnet_name" {
  value       = aws_subnet.nautilus_subnet.tags["Name"]
  description = "The name of the Subnet"
}
```

5. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
