The Nautilus DevOps team wants to provision multiple EC2 instances in AWS using Terraform. Each instance should follow a consistent naming convention and be deployed using a modular and scalable setup.

Use Terraform to:

1. Create 3 EC2 instances using the count parameter.

2. Name each EC2 instance with the prefix datacenter-instance (e.g., datacenter-instance-1).

3. Instances should be t2.micro.

4. The key named should be datacenter-key.

5. Create main.tf file (do not create a separate .tf file) to provision these instances.

6. Use variables.tf file with the following:
   KKE_INSTANCE_COUNT: number of instances.
   KKE_INSTANCE_TYPE: type of the instance.
   KKE_KEY_NAME: name of key used.
   KKE_INSTANCE_PREFIX: name of the instnace.

7. Use the locals.tf file to define a local variable named AMI_ID that retrieves the latest Amazon Linux 2 AMI using a data source.

8. Use terraform.tfvars to assign values to the variables.

9. Use outputs.tf file to output the following:
   kke_instance_names: names of the instances created.


Solution :

1. Create terraform.tfvars file

```
KKE_INSTANCE_COUNT  = 3
KKE_INSTANCE_TYPE   = "t2.micro"
KKE_KEY_NAME        = "nautilus-key"
KKE_INSTANCE_PREFIX = "nautilus-instance"
```

2. Create variables.tf file

```
variable "KKE_INSTANCE_COUNT" {
  type = number
}

variable "KKE_INSTANCE_TYPE" {
  type = string
}

variable "KKE_KEY_NAME" {
  type = string
}

variable "KKE_INSTANCE_PREFIX" {
  type = string
}
```

3. Create main.tf file

```
resource "aws_instance" "nautilus_instance" {
  count         = var.KKE_INSTANCE_COUNT
  ami           = local.AMI_ID
  instance_type = var.KKE_INSTANCE_TYPE
  key_name      = var.KKE_KEY_NAME

  tags = {
    Name = "${var.KKE_INSTANCE_PREFIX}-${count.index + 1}"
  }
}
```

4. Create outputs.tf file

```
output "kke_instance_names" {
  value       = aws_instance.nautilus_instance[*].tags.Name
  description = "The names of the created EC2 instances"
}
```

5. Create locals.tf file

```
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

locals {
  AMI_ID = data.aws_ami.latest_amazon_linux.id
}
```

6. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
