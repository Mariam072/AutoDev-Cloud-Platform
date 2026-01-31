module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.env}-eks-cluster"
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  enable_irsa = true

  cluster_addons = {
    vpc-cni = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
  }

  eks_managed_node_groups = {
    managed_nodes = {
      min_size     = var.node_min
      max_size     = var.node_max
      desired_size = var.node_desired
      iam_role_arn=var.iam_role

      instance_types = var.instance_types
     # key_name       = var.key_name
    }
  }

  fargate_profiles = {
    default = {
      selectors = [
        { namespace = "default" }
      ]
    }
  }
}
