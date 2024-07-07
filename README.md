# Standard Terraform backends:

- AWS S3 Backend (often paired with DynamoDB for state locking)
- Google Cloud Storage Backend
- Azure Storage Backend

Most backends support collaboration features, making them essential for ensuring secure storage and facilitating teamwork. While not all features need to be configured, we'll cover key aspects such as versioning, encryption, and state locking.

# Standard Backend - S3

# Step 1 - Create S3 Bucket and Validate Terraform Configuration
Ensure you have previously set up an S3 bucket to centralize your Terraform state remotely. If not, follow the steps outlined in the previous lab. If already completed, proceed to the next step.

# Step 2 - Validate State on S3 Backend
Verify that you can authenticate to your Terraform backend and access the information in the state file. Confirm that your configuration correctly points to the designated bucket and path.

# Example terraform.tf configuration:

```hcl
terraform {
  backend "s3" {
    bucket = "bucket_name"
    key    = "file_path_in_Bucket"
    region = "us-east-2"
  }
}
```

# Step 3 - Enable Versioning on S3 Bucket
The S3 backend supports versioning, so every revision of your state file is stored. You can enable versioning manually on AWS S3 Bucket configurations.

# Step 4 - Enable Encryption on S3 Bucket 
 Store Terraform state in a backend that supports encryption. Many backends support encryption, ensuring that your state files are encrypted both in transit (e.g., via TLS) and on disk (e.g., via AES-256). The S3 backend supports encryption, which alleviates concerns about storing sensitive data in state files.

Example updated terraform.tf configuration with encryption enabled:

```hcl
terraform {
  backend "s3" {
    bucket = "bucket_name"
    key    = "file_path_in_Bucket"
    region = "us-east-2"
   # encrypt       = true
  }
}
```

# Step 5 - Enable Locking for S3 Backend --> DynamoDB 
The S3 backend supports state locking and consistency checking via DynamoDB to prevent concurrent modifications that could cause corruption. Follow these steps to enable locking:

# Create a DynamoDB Table: Create a DynamoDB table in your AWS account.

Update S3 Backend Configuration: Update your terraform.tf configuration to use the newly created DynamoDB table for locking:

```hcl
terraform {
  backend "s3" {
    bucket = "bucket_name"
    key    = "file_path_in_Bucket"
    region = "us-east-2"
   # dynamodb_table = "terraform-locks"  # Replace with your DynamoDB table name
   # encrypt       = true
  }
}
```

******************************************************************************************************************************


# Terraform Dynamic Block Configuration for Ingress Rules

This Terraform script defines dynamic ingress rules for managing network access to specific ports on your infrastructure.


## Usage

### Variables

In this script, you can adjust the `web_ingress` variable to define ingress rules for different ports and protocols.

```hcl
variable "web_ingress" {
  type = map(object({
    description = string
    port        = number
    protocol    = string
    cidr_block  = list(string)
  }))
  default = {
    "80" = {
      description = "Port 80"
      port        = 80
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
    }
    "443" = {
      description = "Port 443"
      port        = 443
      protocol    = "tcp"
      cidr_block  = ["0.0.0.0/0"]
    }
  }
}
```

### Dynamic Ingress Rules

The dynamic block `ingress` generates ingress rules based on the `web_ingress` configuration.

```hcl
dynamic "ingress" {
  for_each = local.ingress_rules
  content {
    description = ingress.value.description
    from_port   = ingress.value.port
    to_port     = ingress.value.port
    protocol    = ingress.value.protocol
    cidr_block  = ingress.value.cidr_block
  }
}
```

## Customization

Modify the `web_ingress` variable in `variables.tf` to add or adjust ingress rules for different ports and protocols as needed.



# An Example without Dynamic Block:

# aws_security_group.main:
```
resource "aws_security_group" "main" {
    arn                    = "arn:aws:ec2:us-east-1:508140242758:security-group/sg-00157499a6de61832"
    description            = "Managed by Terraform"
    egress                 = []
    id                     = "sg-00157499a6de61832"
    ingress                = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "Port 443"
            from_port        = 443
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 443
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "Port 80"
            from_port        = 80
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 80
        },
    ]
    name                   = "core-sg"
    owner_id               = "508140242758"
    revoke_rules_on_delete = false
    tags_all               = {}
    vpc_id                 = "vpc-0e3a3d76e5feb63c9"
}
```
# Convert Security Group to use dynamic block

```
locals {
  ingress_rules = [{
      port        = 443
      description = "Port 443"
    },
    {
      port        = 80
      description = "Port 80"
    }
  ]
}

resource "aws_security_group" "main" {
  name   = "core-sg"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

### Summary

In this README, we've covered how to configure Terraform for managing dynamic ingress rules and highlighted key backend configurations for state management.

#### Backend Configurations:
- **AWS S3 Backend**: Recommended for storing Terraform state files, supporting features like versioning, encryption, and state locking via DynamoDB.
- **Google Cloud Storage Backend** and **Azure Storage Backend**: Alternative cloud provider options for Terraform state management, offering similar collaboration features.

#### Dynamic Ingress Rules:
- Defined using a Terraform script with a dynamic block, allowing flexible management of network access to specific ports (`web_ingress` variable).

#### Next Steps:
- Customize `web_ingress` in `variables.tf` to add or modify ingress rules according to your infrastructure requirements.
- Consider implementing backend configurations like encryption and state locking for enhanced security and consistency in managing Terraform state.

This README provides a foundational understanding and setup guide for efficiently managing infrastructure configurations with Terraform while leveraging dynamic capabilities for ingress rule management. 
