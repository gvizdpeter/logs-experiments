variable "eks_id" {
  type = string
}

variable "eks_name" {
  type = string
}

variable "aws_tags" {
  type = map(string)
}

variable "worker_iam_role_name" {
  type = string
}

variable "chart_version" {
  type    = string
  default = "9.10.8"
}

variable "namespace" {
  type = string
}

variable "aws_region" {
  type = string
}