# Terraform module for AWS IAM Policy

 A Terraform module which gives us the ability to create any desired IAM policy by setting the statement parameter through input variables such as `sid`, `effect`, `actions` and `resources`.


## Basic usage example for administering IAM resources

```hcl

module "iam_policy" {
  source = "./modules/iam-policy"

  policy_name         = "some_name"
  policy_description  = "Some description"
  statements         = [
    {
      sid        = "AllowS3"
      effect     = "Allow"
      actions    = [               
        "s3:ListBucket"
        "s3:GetObject",
        "s3:PutObject",
      ]
      resources  = ["*"]
      not_resources = []
      condition  = []
      principals = []
    }
  ]

}

```


## Authors

Module created by Bryan Hernandez.
