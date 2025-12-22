variable "name" {
  type        = string
  description = "Name prefix for resources."
}

variable "ami_id" {
  type        = string
  description = "AMI ID to use for the instance."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the instance."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for security group creation."
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether to associate a public IP address."
  default     = false
}

variable "enable_eip" {
  type        = bool
  description = "Whether to allocate and associate an Elastic IP."
  default     = false
}

variable "create_security_group" {
  type        = bool
  description = "Whether to create a security group for the instance."
  default     = true
}

variable "allowed_ingress_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed for inbound traffic. Leave empty to keep inbound closed."
  default     = []
}

variable "root_volume_size" {
  type        = number
  description = "Size of the root EBS volume (GiB)."
  default     = 30
}

variable "root_volume_type" {
  type        = string
  description = "Type of the root EBS volume."
  default     = "gp3"
}

variable "user_data" {
  type        = string
  description = "User data script for the instance."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to resources."
  default     = {}
}
