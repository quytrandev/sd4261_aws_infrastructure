resource "aws_iam_role" "bastion" {
  name               = "bastion-${var.project}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.trust-policies-bastion-assume-role.json
}

resource "aws_iam_role" "bastion_2" {
  name               = "bastion-${var.project}-0002"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.trust-policies-bastion-assume-role.json
}

resource "aws_iam_role_policy" "bastion" {
  name   = "bastion-role-${var.project}-policy"
  role   = aws_iam_role.bastion.id
  policy = data.aws_iam_policy_document.bastion-role-policy.json
}

data "aws_iam_policy_document" "trust-policies-bastion-assume-role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# We define what bastion role can do here Identity-base policies

data "aws_iam_policy_document" "bastion-role-policy" {
  statement {
    actions = [
      "*"
    ]

    resources = [
      "arn:aws:s3:::terraform-boostrap-nashtech-devops"
    ]
  }
}
