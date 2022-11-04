variable "name_prefix" {
  type = string
}
variable "aws_region" {
  type = string
}

variable "natCount" {
  type    = number
}

variable "vpcCidr" {
  type    = string
}

variable "PublicSubnet-List" {
  type = list(object({
    name    = string
    az      = number
    newbits = number
    netnum  = number
  }))
}

variable "PrivateSubnet-List" {
  type = list(object({
    name    = string
    az      = number
    newbits = number
    netnum  = number
  }))
}