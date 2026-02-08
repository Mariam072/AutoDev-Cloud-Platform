resource "aws_security_group" "eks_cluster_sg" {
  name   = "${var.cluster_name}-cluster-sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "eks_node_sg" {
  name   = "${var.cluster_name}-node-sg"
  vpc_id = var.vpc_id
}

# السماح للـ NLB بالوصول للـ NodePort
resource "aws_security_group_rule" "allow_nlb_to_nodes" {
  type                     = "ingress"
  from_port                = var.target_port
  to_port                  = var.target_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node_sg.id
  source_security_group_id = var.nlb_sg_id
}

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

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.env}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = var.node_group_desired_size
    min_size     = var.node_group_min_size
    max_size     = var.node_group_max_size
  }

  instance_types = [var.node_group_instance_type]
}
