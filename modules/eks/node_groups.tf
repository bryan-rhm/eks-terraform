resource "aws_eks_node_group" "ng1" {
  cluster_name = aws_eks_cluster.cluster.name
  labels = {
    "eks/cluster-name"   = aws_eks_cluster.cluster.name
    "eks/nodegroup-name" = format("node-group-%s", aws_eks_cluster.cluster.name)
  }
  node_group_name = format("node-group-%s", aws_eks_cluster.cluster.name)
  node_role_arn   = aws_iam_role.eks-nodegroup-NodeInstanceRole.arn
  instance_types  = [var.worker["instance_type"]]
  disk_size       = var.worker["volume_size"]
  subnet_ids      = var.subnet_ids 

  scaling_config {
    desired_size = var.worker["min_size"]
    max_size     = var.worker["max_size"]
    min_size     = var.worker["min_size"]
  }

  tags = {
    "eks/cluster-name"                                                 = aws_eks_cluster.cluster.name
    "eks/nodegroup-name"                                               = format("${var.environment}-ng1-%s", aws_eks_cluster.cluster.name)
    "eks/nodegroup-type"                                               = "managed"
    "kubernetes.io/cluster-autoscaler/${aws_eks_cluster.cluster.name}" = "true"
    "kubernetes.io/cluster-autoscaler/enabled"                         = "true"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  timeouts {}
}
