resource "aws_eks_cluster" "cluster" {
  enabled_cluster_log_types = var.cluster_log_types
  name                      = "${var.environment}-${var.cluster_name}"

  role_arn = aws_iam_role.eks-cluster-ServiceRole.arn
  tags = merge(
    local.default_tags,
    var.tags,
  )
  version = var.cluster_version

  timeouts {}

  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    security_group_ids      = [aws_security_group.cluster-sg.id]
    subnet_ids              = var.subnet_ids
  }
}
