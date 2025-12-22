output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance."
  value       = aws_instance.this.arn
}

output "private_ip" {
  description = "Private IP address of the instance."
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "Public IP address of the instance, if assigned."
  value       = aws_instance.this.public_ip
}

output "iam_role_name" {
  description = "Name of the IAM role attached to the instance."
  value       = aws_iam_role.ssm_instance.name
}
