variable "storage_class" {
  type = string
}

variable "graylog_host" {
  type = string
}

variable "ingress_class" {
  type = string
}

variable "elasticsearch_address" {
  type = string
}

variable "elasticsearch_username" {
  type      = string
  sensitive = true
}

variable "elasticsearch_password" {
  type      = string
  sensitive = true
}

variable "namespace" {
  type = string
}

variable "chart_version" {
  type    = string
  default = "1.8.10"
}

variable "graylog_replicas" {
  type    = number
  default = 3
}