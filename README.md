# vpc-module
Terraform Module to deploy a VPC


```bash
module "vpc" {
  source      = "git::git@github.com:JManzur/vpc-module.git?ref=v1.0.0"
  name_prefix = "demo-vpc"
  aws_region  = "us-east-1"
  natCount    = 2
  vpcCidr     = "10.10.0.0/16"
  PublicSubnet-List = [
    {
      name    = "Public"
      az      = 0
      newbits = 8
      netnum  = 10
    },
    {
      name    = "Public"
      az      = 1
      newbits = 8
      netnum  = 11
    }
  ]
  PrivateSubnet-List = [
    {
      name    = "Private"
      az      = 0
      newbits = 8
      netnum  = 20
    },
    {
      name    = "Private"
      az      = 1
      newbits = 8
      netnum  = 21
    }
  ]
}
````