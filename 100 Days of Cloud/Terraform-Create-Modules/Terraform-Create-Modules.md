The Nautilus DevOps team is implementing a production-grade, event-driven system using Terraform with workspaces and modules. The goal is to teach advanced Terraform concepts. The requirements are as follows:

1. Use two Terraform workspaces: dev and prod.

2. Implement two Terraform modules:

network module to create a VPC and a subnet.

compute module to create an EC2 instance in the subnet.

3. Use a locals block in the root moduleto define:

A common name prefix: devops-${terraform.workspace}.

Default tags with keys Project = devops and Environment = terraform.workspace.

4. Use main.tf file to define all resources in a structured and modular way, ensuring clarity and maintainability across modules and workspaces.

5. Use variables.tf file from the root module with the following variable names:

KKE_VPC_CIDR:cidr block for the vpc.(10.0.0.0/16)

KKE_INSTANCE_TYPE: EC2 instance type.

6. Use validation in the variables.tf file to ensure that KKE_INSTANCE_TYPE only acceptst3.micro or t3.large, and display an appropriate error message if any other value is provided.

7. The modules must merge the incoming tags with resource-specific Name tags.

8. Use dev.tfvarsand prod.tfvars files with the following:

In dev.tfvars: KKE_INSTANCE_TYPE= t3.micro
In prod.tfvars: KKE_INSTANCE_TYPE =t3.large 9) Use outputs.tf file from the root module with the following output names:

kke_vpc_name: Name of the created VPC.
kke_subnet_name: Name of the created Subnet.
kke_instance_name: Name of the created EC2 instance. 10) Network Module:

Use variables.tf file from the network module with the following variable names:

KKE_NAME_PREFIX: Name prefix to use for network resources.

KKE_VPC_CIDR: CIDR block for the VPC.

KKE_TAGS: Common tags map for network resources.

11. Use outputs.tf file from the network module with the following output names:

kke_vpc_name: Name of the created VPC.

kke_subnet_name: Name of the created Subnet.

12. Compute Module:

Use the Amazon Linux 2 AMI image with ID ami-0c94855ba95c71c99 for the EC2 instance in the compute module.

13. Use variables.tf file from the compute module with the following variable names:

KKE_NAME_PREFIX: Name prefix to use for compute resources.
KKE_SUBNET_ID: Subnet ID where the instance will be created.
KKE_INSTANCE_TYPE: EC2 instance type.
KKE_TAGS: Common tags map for compute resources. 14) Use outputs.tf file from the compute module with the following output names:

kke_instance_name: Name of the created EC2 instance.

Solution :

File structure for this question would look like this

```
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── compute/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── dev.tfvars
└── prod.tfvars
```

1. Create dev.tfvars in the root directory

```
KKE_INSTANCE_TYPE = "t3.micro"
```

2. Create prod.tfvars in the root directory

```
KKE_INSTANCE_TYPE = "t3.large"
```

3. Create variables.tf in the root directory

```
variable "KKE_VPC_CIDR" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "KKE_INSTANCE_TYPE" {
  type        = string
  description = "The EC2 instance type allowed for deployment"

  validation {
    condition     = contains(["t3.micro", "t3.large"], var.KKE_INSTANCE_TYPE)
    error_message = "The KKE_INSTANCE_TYPE variable must be set to either 't3.micro' or 't3.large'."
  }
}

```

4. Create main.tf in the root directory

```
locals {
  name_prefix = "devops-${terraform.workspace}"

  default_tags = {
    Project     = "devops"
    Environment = terraform.workspace
  }
}

# Network Module instantiation
module "network" {
  source          = "./modules/network"
  KKE_NAME_PREFIX = local.name_prefix
  KKE_VPC_CIDR    = var.KKE_VPC_CIDR
  KKE_TAGS        = local.default_tags
}

# Compute Module instantiation
module "compute" {
  source            = "./modules/compute"
  KKE_NAME_PREFIX   = local.name_prefix
  KKE_SUBNET_ID     = module.network.kke_subnet_id # Internal reference block linking modules
  KKE_INSTANCE_TYPE = var.KKE_INSTANCE_TYPE
  KKE_TAGS          = local.default_tags
}
```

5. Create outputs.tf in the root directory

```
output "kke_vpc_name" {
  value       = module.network.kke_vpc_name
  description = "The Name tag of the created VPC"
}

output "kke_subnet_name" {
  value       = module.network.kke_subnet_name
  description = "The Name tag of the created Subnet"
}

output "kke_instance_name" {
  value       = module.compute.kke_instance_name
  description = "The Name tag of the created EC2 instance"
}
```

6. Create variables.tf in the module/compute folder

```
variable "KKE_NAME_PREFIX" {
  type        = string
  description = "Name prefix to use for compute resources"
}

variable "KKE_SUBNET_ID" {
  type        = string
  description = "Subnet ID where the instance will be created"
}

variable "KKE_INSTANCE_TYPE" {
  type        = string
  description = "EC2 instance type"
}

variable "KKE_TAGS" {
  type        = map(string)
  description = "Common tags map for compute resources"
}
```

7. Create main.tf in the module/compute folder

```
resource "aws_instance" "web_app" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = var.KKE_INSTANCE_TYPE
  subnet_id     = var.KKE_SUBNET_ID

  tags = merge(
    var.KKE_TAGS,
    {
      Name = "${var.KKE_NAME_PREFIX}-instance"
    }
  )
}
```

8. Create outputs.tf in the module/compute folder

```
output "kke_instance_name" {
  value       = lookup(aws_instance.web_app.tags, "Name", "${var.KKE_NAME_PREFIX}-instance")
}
```

9. Create variables.tf in the module/network folder

```
variable "KKE_NAME_PREFIX" {
  type        = string
  description = "Name prefix to use for network resources"
}

variable "KKE_VPC_CIDR" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "KKE_TAGS" {
  type        = map(string)
  description = "Common tags map for network resources"
}
```

10. Create main.tf in the module/network folder

```
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.KKE_VPC_CIDR
  enable_dns_hostnames = true

  tags = merge(
    var.KKE_TAGS,
    {
      Name = "${var.KKE_NAME_PREFIX}-vpc"
    }
  )
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(var.KKE_VPC_CIDR, 8, 1) # Yields 10.0.1.0/24 automatically
  tags = merge(
    var.KKE_TAGS,
    {
      Name = "${var.KKE_NAME_PREFIX}-subnet"
    }
  )
}
```

11. Create outputs.tf in the module/network folder

```
output "kke_vpc_name" {
  value       = lookup(aws_vpc.main_vpc.tags, "Name", "${var.KKE_NAME_PREFIX}-vpc")
}

output "kke_subnet_name" {
  value       = lookup(aws_subnet.public_subnet.tags, "Name", "${var.KKE_NAME_PREFIX}-subnet")
}

output "kke_subnet_id" {
  value       = aws_subnet.public_subnet.id
  description = "Passed up to root so compute can ingest it"
}
```

12. Init/Apply terraform files while creating workspaces

```
terraform init

# For dev workspace
terraform workspace new dev
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars" -auto-approve

# For prod workspace
terraform worksapce new prod
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars" -auto-approve
```
