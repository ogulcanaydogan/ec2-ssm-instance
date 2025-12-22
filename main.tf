locals {
  merged_tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_iam_role" "ssm_instance" {
  name               = "${var.name}-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags               = local.merged_tags
}

resource "aws_iam_instance_profile" "ssm_instance" {
  name = "${var.name}-ssm-profile"
  role = aws_iam_role.ssm_instance.name
  tags = local.merged_tags
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_security_group" "this" {
  count       = var.create_security_group ? 1 : 0
  name        = "${var.name}-sg"
  description = "Security group for ${var.name}"
  vpc_id      = var.vpc_id
  tags        = local.merged_tags

  dynamic "ingress" {
    for_each = length(var.allowed_ingress_cidrs) > 0 ? [1] : []
    content {
      description = "Ingress from allowed CIDRs"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = var.allowed_ingress_cidrs
    }
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance.name
  vpc_security_group_ids      = var.create_security_group ? [aws_security_group.this[0].id] : null
  user_data                   = var.user_data

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = true
  }

  tags = local.merged_tags
}

resource "aws_eip" "this" {
  count    = var.enable_eip ? 1 : 0
  domain   = "vpc"
  instance = aws_instance.this.id
  tags     = local.merged_tags
}
