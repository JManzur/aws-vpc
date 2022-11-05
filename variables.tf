variable "name_prefix" {
  description = "[REQUIRED] Prefix to use in VPC resource naming and tagging"
  type        = string
}

variable "aws_region" {
  description = "[REQUIRED] The AWS Region to deploy the resources"
  type        = string
}

variable "one_nat_per_subnet" {
  description = "[REQUIRED] If set to false, only one NAT gateway will be deploy per private subnet"
  type        = bool
}

variable "vpc_cidr" {
  description = "[REQUIRED] The VPC CIDR block, Required format: '0.0.0.0/0'"
  type        = string

  validation {
    condition     = try(cidrhost(var.cidr, 0), null) != null
    error_message = "The CIDR block is invalid. Must be of format '0.0.0.0/0'"
  }
}

variable "public_subnet_list" {
  description = "[REQUIRED] List of key value maps to build the CIDR using the cidrsubnets function, plus the value name and index number for the availability zone"
  type = list(object({
    name    = string
    az      = number
    newbits = number
    netnum  = number
  }))
}

variable "private_subnet_list" {
  description = "[REQUIRED] List of key value maps to build the CIDR using the cidrsubnets function, plus the value name and index number for the availability zone"
  type = list(object({
    name    = string
    az      = number
    newbits = number
    netnum  = number
  }))
}

variable "logs_retention" {
  description = "[REQUIRED] The number of days to retain log events in CloudWatch"
  type        = string #Have to be of type 'string' to be able to perform conditional validation.

  validation {
    condition = (
      var.logs_retention == "0" ||
      var.logs_retention == "1" ||
      var.logs_retention == "3" ||
      var.logs_retention == "5" ||
      var.logs_retention == "7" ||
      var.logs_retention == "14" ||
      var.logs_retention == "30" ||
      var.logs_retention == "60" ||
      var.logs_retention == "90" ||
      var.logs_retention == "120" ||
      var.logs_retention == "150" ||
      var.logs_retention == "180" ||
      var.logs_retention == "365" ||
      var.logs_retention == "400" ||
      var.logs_retention == "545" ||
      var.logs_retention == "731" ||
      var.logs_retention == "1827" ||
      var.logs_retention == "3653"
    )
    error_message = "The value must be one of the followings: 0,1,3,5,7,14,30,60,90,120,150,180,365,400,545,731,1827,3653."
  }
}