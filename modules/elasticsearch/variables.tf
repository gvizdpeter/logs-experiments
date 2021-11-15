variable "aws_tags" {
  type = map(string)
}

variable "instance_type" {
  type    = string
  default = "t3.small.elasticsearch"
}

variable "instance_count" {
  type    = number
  default = 3
  validation {
    condition     = var.instance_count >= 3
    error_message = "Minimal instance_count is 3."
  }
}

variable "elasticsearch_version" {
  type    = string
  default = "7.10"
}

variable "domain_name" {
  type = string
}

variable "client_security_group_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "elasticsearch_exporter_chart_version" {
  type    = string
  default = "4.7.0"
}