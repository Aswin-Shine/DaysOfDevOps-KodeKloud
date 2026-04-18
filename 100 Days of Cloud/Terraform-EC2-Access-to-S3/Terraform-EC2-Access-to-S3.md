Solution :

1. Create terraform.tfvars file

```
KKE_BUCKET_NAME = "devops-logs-15665"
KKE_ROLE_NAME   = "devops-role"
KKE_POLICY_NAME = "devops-access-policy"
```

2. Create variables.tf file

```
variable "KKE_BUCKET_NAME" {
  type = string
}

variable "KKE_ROLE_NAME" {
  type = string
}

variable "KKE_POLICY_NAME" {
  type = string
}
```

3. Create data.tf file

```
data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
```

4. Create main.tf file

```
# 1. Create S3 Bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = var.KKE_BUCKET_NAME
}

# 2. Create IAM Role with AssumeRole Policy
resource "aws_iam_role" "devops_role" {
  name = var.KKE_ROLE_NAME

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# 3. Create IAM Policy for S3 PutObject
resource "aws_iam_policy" "devops_policy" {
  name = var.KKE_POLICY_NAME

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:PutObject"
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.log_bucket.arn}/*"
      }
    ]
  })
}

# 4. Attach Policy to Role
resource "aws_iam_role_policy_attachment" "role_attach" {
  role       = aws_iam_role.devops_role.name
  policy_arn = aws_iam_policy.devops_policy.arn
}

# 5. Create Instance Profile (This "wraps" the role for EC2)
resource "aws_iam_instance_profile" "devops_profile" {
  name = "${var.KKE_ROLE_NAME}-profile"
  role = aws_iam_role.devops_role.name
}

# 6. Create EC2 Instance
resource "aws_instance" "devops_ec2" {
  ami                  = data.aws_ami.latest_amazon_linux.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.devops_profile.name

  tags = {
    Name = "devops-ec2"
  }
}
```

5. Create outputs.tf file

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

6. Init/Apply all the terraform files

```
terraform init
terraform plan
terraform apply -auto-approve

```
