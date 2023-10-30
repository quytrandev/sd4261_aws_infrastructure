data "aws_caller_identity" "current" {}
provider "aws" {
  region = var.region
}

locals {
  name = "${module.tags_dev.name}-eks"

  service_account_namespace    = "kube-system"
  ebs_csi_service_account_name = "ebs-csi-controller-sa"

  tags = {
    Name = local.name
  }
}
###########################################################################################
#VPC for EC2, ECR and EKS
###########################################################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = local.name
  cidr = var.cidr_block

  azs             = var.azs
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs
  intra_subnets   = var.intra_subnet_cidrs

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true


  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/elb"              = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = 1
  }
}

###########################################################################################
#EC2 Instance and supports
###########################################################################################
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = "${module.tags_dev.name}-ec2"
  ami                         = "ami-00970f57473724c10" //Amazon Linux 2023 AMI
  instance_type               = "t3.large"              //Large tier instance to meet Docker specs requirements
  key_name                    = "jenkins-key"
  monitoring                  = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  subnet_id                   = module.vpc.public_subnets[0] 
  associate_public_ip_address = true
}
resource "aws_security_group" "ec2_sg" {
  name   = "Security Group for EC2 under provisioning"
  vpc_id = module.vpc.vpc_id

 ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
###########################################################################################
#ECR
###########################################################################################
module "ecr_frontend" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "${module.tags_dev.name}-ecr-frontend"
repository_image_tag_mutability = "IMMUTABLE" //allow to override image as pushing
  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
  repository_force_delete = true
  
}

module "ecr_backend" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "${module.tags_dev.name}-ecr-backend"
repository_image_tag_mutability = "IMMUTABLE" //allow to override image as pushing
  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
  repository_force_delete = true
  
}

###########################################################################################
#Elastic Kubernetes Services
###########################################################################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.1"

  cluster_name                   = local.name
  cluster_endpoint_public_access = true
  enable_irsa                    = true
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${module.eks.cluster_name}-ebs-csi-controller"
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["m5.large"]

    attach_cluster_primary_security_group = true
  }

  node_security_group_tags = {
    "kubernetes.io/cluster/${local.name}" = null //tag null for security group to allow Load Balancer to be created since it won't create as EC2 got many tags
  }
  eks_managed_node_groups = {
    qt-cluster-wg = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"

      tags = {
        Name = "eks-managed-node-group"
      }
    }
  }

  tags = local.tags
}

//Permission for EBS
module "ebs_csi_controller_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.11.1"
  create_role                   = true
  role_name                     = "${module.eks.cluster_name}-ebs-csi-controller"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.ebs_csi_controller.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.service_account_namespace}:${local.ebs_csi_service_account_name}"]
}

resource "aws_iam_policy" "ebs_csi_controller" {
  name_prefix = "ebs-csi-controller"
  description = "EKS ebs-csi-controller policy for cluster ${module.eks.cluster_name}"
  policy      = file("../ebs_csi_controller_iam_policy.json")
}