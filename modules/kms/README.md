# AWS KNS Terraform module

Terraform module which creates a KMS key.

* [Amazon KMS ](https://aws.amazon.com/kms/)

This module creates the KMS Key needed by any application stack

# Usage

You'll need to have your AWS_PROFILE loaded up. Once you do, the module will ask you for the variables that you'll want to set as seen below (e.g.):

## KMS module example

```hcl
module "kms" {
  source = "./kms"

  # AWS profiler settings
  providers = {
    aws = "aws.admin"
  }

  key_alias                          = dev
  principal                          = "048333165348"
  tags                               = { project = "eMed" }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.13.4 |
| aws | ~> 3.43.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.43.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| deletion\_window\_in\_days | Duration in days after which the key is deleted after destruction of the resource | `number` | `10` | no |
| enable\_key\_rotation | Enable the rotation of the KMS key created | `bool` | `false` | no |
| key\_alias | Alias of the key to be created | `string` | n/a | yes |
| key\_description | Description of the purpose of the KMS key | `string` | `"KMS key for encrypting sensitive data"` | no |
| principal | AWS Principal allowed to use the key | `string` | `""` | no |
| tags | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| kms\_alias\_arn | n/a |
| kms\_alias\_name | n/a |
| kms\_key\_arn | n/a |
| kms\_key\_id | n/a |

