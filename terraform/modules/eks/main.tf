#################################
# Security Groups
#################################

resource "aws_security_group" "eks_cluster_sg" {
  name   = "${var.cluster_name}-cluster-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "eks_node_sg" {
  name   = "${var.cluster_name}-node-sg"
  vpc_id = var.vpc_id
}


resource "aws_security_group_rule" "cluster_ingress_from_nodes" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_node_sg.id
}


resource "aws_security_group_rule" "node_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.eks_node_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "allow_nodeport_from_vpc" {
  type              = "ingress"
  from_port         = var.target_port
  to_port           = var.target_port
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_node_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

#################################
# EKS Cluster
#################################

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = "1.29"

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = [aws_security_group.eks_cluster_sg.id]

    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

#################################
# EKS Managed Node Group
#################################

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.env}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnets

  instance_types = [var.node_group_instance_type]

  scaling_config {
    desired_size = var.node_group_desired_size
    min_size     = var.node_group_min_size
    max_size     = var.node_group_max_size
  }


  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_security_group_rule.cluster_ingress_from_nodes,
    aws_security_group_rule.node_egress_all
  ]
}
