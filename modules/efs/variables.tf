variable "worker_iam_role_name" {
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

variable "config_path" {
  type = string
}