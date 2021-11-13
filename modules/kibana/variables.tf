variable "kibana_host" {
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

variable "config_path" {
  type = string
}

variable "config_context" {
  type = string
}