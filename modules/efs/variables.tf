variable "client_iam_role_name" {
  type = string
}

variable "aws_tags" {
  type = map(string)
}

variable "subnets" {
  type = list(string)
}

variable "client_security_group_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "storage_class_name" {
  type = string
}

variable "chart_version" {
  type    = string
  default = "2.2.0"
}

variable "namespace" {
  type = string
}