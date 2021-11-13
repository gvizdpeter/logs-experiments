variable "aws_tags" {
  type = map(string)
}

variable "elasticsearch_host" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
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

variable "config_path" {
  type = string
}

variable "config_context" {
  type = string
}