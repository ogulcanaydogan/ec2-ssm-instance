# ec2-ssm-instance

Terraform module to launch an EC2 instance managed by AWS Systems Manager (SSM) with no SSH access by default.

## Features

- EC2 instance with IMDSv2 enforced.
- IAM role + instance profile attached with `AmazonSSMManagedInstanceCore`.
- Optional security group (no inbound rules by default).
- Encrypted root EBS volume with configurable size and type.
- Optional user data and Elastic IP.

## Usage

```hcl
module "ec2_ssm_instance" {
  source = "../.."

  name          = "app"
  ami_id        = "ami-1234567890abcdef0"
  instance_type = "t3.micro"
  subnet_id     = "subnet-1234567890abcdef0"
  vpc_id        = "vpc-1234567890abcdef0"

  tags = {
    Environment = "dev"
  }
}
```

## Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| name | string | n/a | Name prefix for resources. |
| ami_id | string | n/a | AMI ID to use for the instance. |
| instance_type | string | n/a | EC2 instance type. |
| subnet_id | string | n/a | Subnet ID for the instance. |
| vpc_id | string | n/a | VPC ID for security group creation. |
| associate_public_ip_address | bool | false | Whether to associate a public IP address. |
| enable_eip | bool | false | Whether to allocate and associate an Elastic IP. |
| create_security_group | bool | true | Whether to create a security group for the instance. |
| allowed_ingress_cidrs | list(string) | [] | CIDR blocks allowed for inbound traffic. Leave empty to keep inbound closed. |
| root_volume_size | number | 30 | Size of the root EBS volume (GiB). |
| root_volume_type | string | "gp3" | Type of the root EBS volume. |
| user_data | string | null | User data script for the instance. |
| tags | map(string) | {} | Additional tags to apply to resources. |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | ID of the EC2 instance. |
| instance_arn | ARN of the EC2 instance. |
| private_ip | Private IP address of the instance. |
| public_ip | Public IP address of the instance, if assigned. |
| iam_role_name | Name of the IAM role attached to the instance. |

## Examples

- [Minimal](./examples/minimal)
- [Public instance with EIP](./examples/public_instance_with_eip)
