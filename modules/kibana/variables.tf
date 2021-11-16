variable "subdomain" {
  type    = string
  default = "kibana"
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
  default = "7.10.2"
}

variable "zone_id" {
  type = string
}

variable "zone_name" {
  type = string
}