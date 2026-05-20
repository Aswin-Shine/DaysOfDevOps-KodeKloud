The DevOps team is building a Terraform-based AWS pipeline using strict modular design, symbolic links for configuration reuse, and a sequential resource flow

1. Create modules under modules/ named:

SNS Module: Create an SNS topic named nautilus-sns-topic.
SSM Module: Create an SSM Parameter named nautilus-param storing the ARN of the SNS topic from the SNS module. The SSM parameter should be of type String.
Step Functions Module: Create a Step Functions state machine named nautilus-stepfunction that retrieves the SNS topic ARN from the SSM Parameter. The Step Function should have an IAM role with a policy allowing ssm:GetParameter access to read the parameter.

2. Use symbolic links to reuse the root variables.tf file across all modules (no duplicated variable declarations inside module main.tf files). Ensure the symlink uses an absolute path.

3. Create a single main.tf in the root to orchestrate the module calls in sequence SNS → SSM → Step Functions. Pass the SNS ARN output from the SNS module to the SSM module, and the SSM parameter name output from the SSM module to the Step Functions module.

4. Use the depends_on feature so that SSM depends on SNS and StepFunctions depend on SSM.

5. Use variables.tf file with the following variable names:

KKE_SNS_TOPIC_NAME: name of the SNS topic.
KKE_SSM_PARAM_NAME: SSM parameter name.
KKE_STEP_FUNCTION_NAME: Step Function name.

6. Use terraform.tfvars file to input the values of the variables.

7. Use outputs.tf file with the following variables:

kke_sns_topic_name: name of the SNS topic created.
kke_ssm_parameter_name: name of the SSM parameter created.
kke_step_function_name: name of the Step Function created.

8. Additional implementation hints:

SNS Module: output both name and ARN of the topic.
SSM Module: set the value of the parameter to the SNS ARN received from the SNS module. Also, ensure the SSM parameter implementation creates a direct Terraform dependency on the SNS topic so that the dependency is visible in the Terraform graph.
Step Functions Module: create an IAM role and policy allowing ssm:GetParameter, then assign the role to the state machine. The Step Function can use a simple placeholder definition (e.g., Pass state) for this task.

Solution :

File structure for this question would look like this

```
/home/bob/terraform/
├── main.tf                     # Central Root Orchestrator (SNS -> SSM -> SFN)
├── variables.tf                # Central Shared Variable Schema (The Source File)
├── outputs.tf                  # Central Output Collector
├── terraform.tfvars            # Central Variable Input Definitions
└── modules/
    ├── sns/
    │   ├── main.tf             # Topic resource blocks
    │   ├── outputs.tf          # Exports kke_sns_topic_name & sns_topic_arn
    │   └── variables.tf        ---> Absolute Symlink to /home/bob/terraform/variables.tf
    ├── ssm/
    │   ├── main.tf             # Parameter resource blocks
    │   ├── outputs.tf          # Exports kke_ssm_parameter_name
    │   └── variables.tf        ---> Absolute Symlink to /home/bob/terraform/variables.tf
    └── step_functions/
        ├── main.tf             # State Machine & IAM Access Policy blocks
        ├── outputs.tf          # Exports kke_step_function_name
        └── variables.tf        ---> Absolute Symlink to /home/bob/terraform/variables.tf
```

1. Create a shell script for creating the folder structure and empty terraform files. (build-infra.sh)

```
#!/usr/bin/env bash
set -euo pipefail

# Define core directory path anchoring
BASE_DIR="/home/bob/terraform"

echo "🚀 Bootstrapping empty structural layout under ${BASE_DIR}..."

# 1. Create directory paths for root layout and all components
mkdir -p "${BASE_DIR}/modules/sns"
mkdir -p "${BASE_DIR}/modules/ssm"
mkdir -p "${BASE_DIR}/modules/step_functions"

# 2. Touch completely blank root orchestration files
touch "${BASE_DIR}/main.tf"
touch "${BASE_DIR}/variables.tf"
touch "${BASE_DIR}/outputs.tf"
touch "${BASE_DIR}/terraform.tfvars"

# 3. Touch completely blank individual component module files
touch "${BASE_DIR}/modules/sns/main.tf"
touch "${BASE_DIR}/modules/sns/outputs.tf"

touch "${BASE_DIR}/modules/ssm/main.tf"
touch "${BASE_DIR}/modules/ssm/outputs.tf"

touch "${BASE_DIR}/modules/step_functions/main.tf"
touch "${BASE_DIR}/modules/step_functions/outputs.tf"

# 4. Generate absolute-path symbolic links to share the root variables.tf across modules
echo "🔗 Creating absolute-path symbolic links for variables.tf..."
for TARGET_MOD in sns ssm step_functions; do
  ln -sf "${BASE_DIR}/variables.tf" "${BASE_DIR}/modules/${TARGET_MOD}/variables.tf"
done

echo "======================================================================"
echo "✅ Fresh, blank environment with proper absolute symlinks ready!"
echo "📍 Location root: cd ${BASE_DIR}"
echo "======================================================================"
```

2. Run this script file

```
chmod +x build-infra.sh
./build-infra.sh
```

3. Edit variables.tf file (/home/bob/terraform/)

```
variable "KKE_SNS_TOPIC_NAME" {
  type        = string
  description = "The precise name string for the Amazon SNS topic"
}

variable "KKE_SSM_PARAM_NAME" {
  type        = string
  description = "The target parameter store key path identifier for AWS SSM"
}

variable "KKE_STEP_FUNCTION_NAME" {
  type        = string
  description = "The descriptive name for the AWS Step Functions State Machine"
}
```

4. Edit main.tf file (/home/bob/terraform/)

```
# Step A: Provision SNS
module "sns" {
  source             = "./modules/sns"
  KKE_SNS_TOPIC_NAME = var.KKE_SNS_TOPIC_NAME
}

# Step B: Provision SSM (Explicitly consuming SNS output and using depends_on)
module "ssm" {
  source             = "./modules/ssm"
  KKE_SSM_PARAM_NAME = var.KKE_SSM_PARAM_NAME
  sns_topic_arn      = module.sns.sns_topic_arn

  depends_on = [module.sns]
}

# Step C: Provision Step Functions (Consuming SSM output and using depends_on)
module "step_functions" {
  source                 = "./modules/step_functions"
  KKE_STEP_FUNCTION_NAME = var.KKE_STEP_FUNCTION_NAME
  ssm_parameter_name     = module.ssm.kke_ssm_parameter_name

  depends_on = [module.ssm]
}
```

5. Edit outputs.tf file (/home/bob/terraform/)

```
output "kke_sns_topic_name" {
  value       = module.sns.kke_sns_topic_name
  description = "Name of the SNS topic created"
}

output "kke_ssm_parameter_name" {
  value       = module.ssm.kke_ssm_parameter_name
  description = "Name of the SSM parameter created"
}

output "kke_step_function_name" {
  value       = module.step_functions.kke_step_function_name
  description = "Name of the Step Function created"
}
```

6. Edit the terraform.tfvars file (/home/bob/terraform/)

```
KKE_SNS_TOPIC_NAME     = "nautilus-sns-topic"
KKE_SSM_PARAM_NAME     = "nautilus-param"
KKE_STEP_FUNCTION_NAME = "nautilus-stepfunction"
```

7. Edit main.tf file (/home/bob/terraform/modules/sns/)

```
resource "aws_sns_topic" "topic" {
  name = var.KKE_SNS_TOPIC_NAME
}
```

8. Edit outputs.tf file (/home/bob/terraform/modules/sns/)

```
output "kke_sns_topic_name" {
  value = aws_sns_topic.topic.name
}

output "sns_topic_arn" {
  value = aws_sns_topic.topic.arn
}
```

9. Edit main.tf file (/home/bob/terraform/modules/ssm/)

```
variable "sns_topic_arn" {
  type        = string
  description = "Explicit input variable injected directly from root orchestration to maintain dependency graph lineage"
}

resource "aws_ssm_parameter" "param" {
  name        = var.KKE_SSM_PARAM_NAME
  type        = "String"
  value       = var.sns_topic_arn
  description = "Dynamically injected SNS Topic ARN pointer string"
}
```

10. Edit outputs.tf file (/home/bob/terraform/modules/ssm/)

```
output "kke_ssm_parameter_name" {
  value = aws_ssm_parameter.param.name
}
```

11. Edit main.tf file (/home/bob/terraform/modules/setupfunctions/)

```
variable "ssm_parameter_name" {
  type        = string
  description = "Target reference to SSM Parameter passed downstream"
}

# IAM Execution Role for State Machine
resource "aws_iam_role" "sfn_role" {
  name = "${var.KKE_STEP_FUNCTION_NAME}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = { Service = "states.amazonaws.com" }
      }
    ]
  })
}

# Policy allowing ssm:GetParameter access to read the token
resource "aws_iam_policy" "sfn_ssm_policy" {
  name        = "${var.KKE_STEP_FUNCTION_NAME}-ssm-policy"
  description = "Allows explicit retrieval authorization profile over the pipeline SSM parameters"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [ "ssm:GetParameter" ]
        Resource = [ "arn:aws:ssm:*:*:parameter/${var.ssm_parameter_name}" ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.sfn_role.name
  policy_arn = aws_iam_policy.sfn_ssm_policy.arn
}

# State Machine with a clean, functional Pass State placeholder configuration
resource "aws_sfn_state_machine" "state_machine" {
  name     = var.KKE_STEP_FUNCTION_NAME
  role_arn = aws_iam_role.sfn_role.arn

  definition = jsonencode({
    Comment = "Nautilus execution pipeline targeting SSM state retrieval orchestration"
    StartAt = "RetrieveSnsArnToken"
    States = {
      RetrieveSnsArnToken = {
        Type     = "Pass"
        Result   = "SSM parameter referenced cleanly by execution stack graph lookup"
        End      = true
      }
    }
  })

  depends_on = [aws_iam_role_policy_attachment.attach_policy]
}
```

12. Edit outputs.tf file (/home/bob/terraform/modules/setupfunctions)

```
output "kke_step_function_name" {
  value = aws_sfn_state_machine.state_machine.name
}
```

13. Init/Apply the terraform files.

```
terrform init
terraform plan
terraform apply -auto-approve
```
