# resource "aws_iam_role" "alb_ingress" {
#   name               = "irsa-alb-ingress-${var.project-name}-${var.environment}"
#   path               = "/"
#   assume_role_policy = data.aws_iam_policy_document.irsa_alb_role_trust_relationship.json
# }

# resource "aws_iam_policy" "irsa_alb_role_policy" {
#   name        = "irsa-alb-ingress-${var.project-name}-${var.environment}"
#   path        = "/"
#   description = "Policy for IRSA ALB Ingress"

#   policy = data.aws_iam_policy_document.irsa_alb_role_policy.json
# }

# resource "aws_iam_role_policy_attachment" "irsa_alb_role_policy_attachment" {
#   role       = aws_iam_role.alb_ingress.name
#   policy_arn = aws_iam_policy.irsa_alb_role_policy.arn
# }

# data "aws_iam_policy_document" "irsa_alb_role_trust_relationship" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRoleWithWebIdentity"]

#     condition {
#       test     = "StringLike"
#       variable = "${module.eks.oidc_provider}:sub"
#       values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
#     }

#     principals {
#       type        = "Federated"
#       identifiers = [module.eks.oidc_provider_arn]
#     }
#   }
# }

# data "aws_iam_policy_document" "irsa_alb_role_policy" {
#   statement {
#     effect    = "Allow"
#     resources = ["*"]

#     actions = [
#       "acm:DescribeCertificate",
#       "acm:ListCertificates",
#       "ec2:AuthorizeSecurityGroupIngress",
#       "ec2:CreateSecurityGroup",
#       "ec2:DescribeAccountAttributes",
#       "ec2:DescribeAddresses",
#       "ec2:DescribeAvailabilityZones",
#       "ec2:DescribeCoipPools",
#       "ec2:DescribeInstances",
#       "ec2:DescribeInternetGateways",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DescribeSecurityGroups",
#       "ec2:DescribeSubnets",
#       "ec2:DescribeTags",
#       "ec2:DescribeVpcs",
#       "ec2:GetCoipPoolUsage",
#       "ec2:RevokeSecurityGroupIngress",
#       "elasticloadbalancing:DescribeListenerCertificates",
#       "elasticloadbalancing:DescribeListeners",
#       "elasticloadbalancing:DescribeLoadBalancerAttributes",
#       "elasticloadbalancing:DescribeLoadBalancers",
#       "elasticloadbalancing:DescribeRules",
#       "elasticloadbalancing:DescribeSSLPolicies",
#       "elasticloadbalancing:DescribeTags",
#       "elasticloadbalancing:DescribeTargetGroupAttributes",
#       "elasticloadbalancing:DescribeTargetGroups",
#       "elasticloadbalancing:DescribeTargetHealth",
#       "iam:CreateServiceLinkedRole",
#       "iam:GetServerCertificate",
#       "iam:ListServerCertificates",
#       "shield:CreateProtection",
#       "shield:DeleteProtection",
#       "shield:DescribeProtection",
#       "shield:GetSubscriptionState",
#       "waf-regional:AssociateWebACL",
#       "waf-regional:DisassociateWebACL",
#       "waf-regional:GetWebACL",
#       "waf-regional:GetWebACLForResource",
#       "wafv2:AssociateWebACL",
#       "wafv2:DisassociateWebACL",
#       "wafv2:GetWebACL",
#       "wafv2:GetWebACLForResource",
#     ]
#   }

#   statement {
#     sid       = ""
#     effect    = "Allow"
#     resources = ["arn:aws:ec2:*:*:security-group/*"]
#     actions   = ["ec2:CreateTags"]

#     condition {
#       test     = "StringEquals"
#       variable = "ec2:CreateAction"
#       values   = ["CreateSecurityGroup"]
#     }

#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
#       values   = ["false"]
#     }
#   }

#   statement {
#     sid       = ""
#     effect    = "Allow"
#     resources = ["arn:aws:ec2:*:*:security-group/*"]

#     actions = [
#       "ec2:CreateTags",
#       "ec2:DeleteTags",
#     ]

#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
#       values   = ["true"]
#     }

#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
#       values   = ["false"]
#     }
#   }

#   statement {
#     sid       = ""
#     effect    = "Allow"
#     resources = ["*"]

#     actions = [
#       "ec2:AuthorizeSecurityGroupIngress",
#       "ec2:RevokeSecurityGroupIngress",
#       "ec2:DeleteSecurityGroup",
#     ]

#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
#       values   = ["false"]
#     }
#   }

#   statement {
#     sid       = ""
#     effect    = "Allow"
#     resources = ["*"]

#     actions = [
#       "elasticloadbalancing:CreateLoadBalancer",
#       "elasticloadbalancing:CreateTargetGroup",
#     ]

#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
#       values   = ["false"]
#     }
#   }

#   statement {
#     sid       = ""
#     effect    = "Allow"
#     resources = ["*"]

#     actions = [
#       "elasticloadbalancing:CreateListener",
#       "elasticloadbalancing:DeleteListener",
#       "elasticloadbalancing:CreateRule",
#       "elasticloadbalancing:DeleteRule",
#     ]
#   }

#   statement {
#     sid    = ""
#     effect = "Allow"

#     resources = [
#       "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
#       "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
#       "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*",
#     ]

#     actions = [
#       "elasticloadbalancing:AddTags",
#       "elasticloadbalancing:RemoveTags",
#     ]

#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
#       values   = ["true"]
#     }

#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
#       values   = ["false"]
#     }
#   }

#   statement {
#     sid    = ""
#     effect = "Allow"

#     resources = [
#       "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
#       "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
#       "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
#       "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*",
#     ]

#     actions = [
#       "elasticloadbalancing:AddTags",
#       "elasticloadbalancing:RemoveTags",
#     ]
#   }

#   statement {
#     sid       = ""
#     effect    = "Allow"
#     resources = ["*"]

#     actions = [
#       "elasticloadbalancing:ModifyLoadBalancerAttributes",
#       "elasticloadbalancing:SetIpAddressType",
#       "elasticloadbalancing:SetSecurityGroups",
#       "elasticloadbalancing:SetSubnets",
#       "elasticloadbalancing:DeleteLoadBalancer",
#       "elasticloadbalancing:ModifyTargetGroup",
#       "elasticloadbalancing:ModifyTargetGroupAttributes",
#       "elasticloadbalancing:DeleteTargetGroup",
#     ]

#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
#       values   = ["false"]
#     }
#   }

#   statement {
#     sid       = ""
#     effect    = "Allow"
#     resources = ["arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"]

#     actions = [
#       "elasticloadbalancing:RegisterTargets",
#       "elasticloadbalancing:DeregisterTargets",
#     ]
#   }

#   statement {
#     sid       = ""
#     effect    = "Allow"
#     resources = ["*"]

#     actions = [
#       "elasticloadbalancing:SetWebAcl",
#       "elasticloadbalancing:ModifyListener",
#       "elasticloadbalancing:AddListenerCertificates",
#       "elasticloadbalancing:RemoveListenerCertificates",
#       "elasticloadbalancing:ModifyRule",
#     ]
#   }
# }
