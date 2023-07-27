# resource "aws_iam_role" "external_dns" {
#   name               = "irsa-external-dns-${var.project-name}-${var.environment}"
#   path               = "/"
#   assume_role_policy = data.aws_iam_policy_document.irsa_external_dns_role_trust_relationship.json
# }

# resource "aws_iam_policy" "irsa_external_dns_role_policy" {
#   name        = "irsa-external-dns-ingress-${var.project-name}-${var.environment}"
#   path        = "/"
#   description = "Policy for IRSA External DNS"

#   policy = data.aws_iam_policy_document.irsa_external_dns_role_policy.json
# }

# resource "aws_iam_role_policy_attachment" "irsa_external_dns_role_policy_attachment" {
#   role       = aws_iam_role.external_dns.name
#   policy_arn = aws_iam_policy.irsa_external_dns_role_policy.arn
# }

# data "aws_iam_policy_document" "irsa_external_dns_role_trust_relationship" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     condition {
#       test     = "StringLike"
#       variable = "${module.eks.oidc_provider}:sub"
#       values   = ["system:serviceaccount:kube-system:external-dns"]
#     }

#     principals {
#       type        = "Federated"
#       identifiers = [module.eks.oidc_provider_arn]
#     }
#   }
# }

# data "aws_iam_policy_document" "irsa_external_dns_role_policy" {
#   statement {
#     effect    = "Allow"
#     resources = ["arn:aws:route53:::hostedzone/*"]
#     actions   = ["route53:ChangeResourceRecordSets"]
#   }

#   statement {
#     sid       = ""
#     effect    = "Allow"
#     resources = ["*"]

#     actions = [
#       "route53:ListHostedZones",
#       "route53:ListResourceRecordSets",
#     ]
#   }
# }
