resource "aws_iam_role" "eks-cluster-ServiceRole" {
  name                  = "${var.environment}-eks-cluster-ServiceRole"
  path                  = "/"
  force_detach_policies = false
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = [
              "eks-fargate-pods.amazonaws.com",
              "eks.amazonaws.com",
            ]
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  
  max_session_duration  = 3600
  managed_policy_arns   = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]
  
}

resource "aws_iam_role_policy" "eks-cluster-ServiceRole-ELBPermissions" {
  name = "${var.environment}-eks-cluster-PolicyELBPermissions"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "ec2:DescribeAccountAttributes",
            "ec2:DescribeAddresses",
            "ec2:DescribeInternetGateways",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
      Version = "2012-10-17"
    }
  )
  role = aws_iam_role.eks-cluster-ServiceRole.id
}

resource "aws_iam_role_policy" "eks-cluster-ServiceRole-CloudWatchMetrics" {
  name = "${var.environment}-eks-cluster-PolicyCloudWatchMetrics"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "cloudwatch:PutMetricData",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
      Version = "2012-10-17"
    }
  )
  role = aws_iam_role.eks-cluster-ServiceRole.id
}
