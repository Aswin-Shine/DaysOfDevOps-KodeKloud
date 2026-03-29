Solution :

1. Create main.tf file

```
# 1. Create the RSA Key Pair
resource "tls_private_key" "nautilus_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "nautilus_kp" {
  key_name   = "nautilus-kp"
  public_key = tls_private_key.nautilus_key.public_key_openssh
}

# 2. Launch the EC2 Instance
resource "aws_instance" "nautilus_server" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.nautilus_kp.key_name

  # Using the default security group
  # Note: If no VPC is specified, AWS uses the default security group of the default VPC
  security_groups = ["default"]

  tags = {
    Name = "nautilus-ec2"
  }
}

# Output the Private Key (Optional - for local access)
output "private_key" {
  value     = tls_private_key.nautilus_key.private_key_pem
  sensitive = true
}
```

2. Initiate & apply the terraform file

```
terraform init

terraform plan

terraform apply -auto-aprrove

```
