resource "aws_lb" "this" {
  name               = "${var.env}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_subnets

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "this" {
  name        = "${var.env}-nlb-tg"
  port        = var.target_port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    protocol = "TCP"
    port     = var.target_port
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# جلب الـ Node Group من الـ EKS
data "aws_eks_node_group" "default" {
  cluster_name    = var.eks_cluster_name
  node_group_name = var.eks_node_group_name
}

# جلب الـ EC2 instance IDs للـ Node Group
data "aws_instances" "eks_nodes" {
  filter {
    name   = "tag:eks:nodegroup-name"
    values = [data.aws_eks_node_group.default.node_group_name]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

# ربط الـ NLB بالـ nodes
resource "aws_lb_target_group_attachment" "this" {
  for_each         = toset(data.aws_instances.eks_nodes.ids)
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = each.value
  port             = var.target_port
}
