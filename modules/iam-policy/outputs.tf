output "output" {
  value = {
    policy_arn = aws_iam_policy.this.arn
  }
}