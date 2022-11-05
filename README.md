# AWS VPC Terraform Module

Terraform Module to deploy a VPC

```bash
module "vpc" {
  source             = "git::https://github.com/JManzur/aws-vpc.git?ref=v1.0.0"
  name_prefix        = "demo-vpc"
  aws_region         = "us-east-1"
  one_nat_per_subnet = true
  vpc_cidr           = "10.10.0.0/16"
  public_subnet_list = [
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
  private_subnet_list = [
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