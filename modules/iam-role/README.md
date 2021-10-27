## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |


## Example Usage

```hcl
module "iam_backend_role" {
  source             = "./modules/iam-role"
  role_name          = "EC2Role"
  trusted_identifier = {
    type        = "Service"
    identifiers = ["ec2.amazonaws.com"]
  }
  iam_policies_to_attach = ["arn:iam:policy:/example-policy"]
}

```

## Resources

| Name |
|------|
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| description | Description for the IAM role | `string` | `"Created by terraform"` | no |
| iam\_policies\_to\_attach | List of ARNs of IAM policies to attach | `list(string)` | `[]` | no |
| role\_name | Name for the role | `string` | n/a | yes |
| trusted\_identifier | Entity allowed to assume the role | <pre>object({<br>    type        = string       # Ex: AWS<br>    identifiers = list(string) # Ex: Account id (1234424) | AWS service  ec2.amazonaws.com<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| output | Iam role object |

## Authors

Module created by Bryan Hernandez.