variable "storage_class" {
  type = string
}

variable "namespace" {
  type = string
}

variable "subdomain" {
  type    = string
  default = "prometheus"
}

variable "ingress_class" {
  type = string
}

variable "prometheus_chart_version" {
  type    = string
  default = "14.11.0"
}

variable "prometheus_adapter_chart_version" {
  type    = string
  default = "3.0.0"
}

variable "zone_id" {
  type = string
}

variable "zone_name" {
  type = string
}