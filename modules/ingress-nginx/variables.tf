variable "namespace" {
  type = string
}

variable "ingress_class_name" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "logstash_namespace" {
  type = string
}

variable "logstash_service_name" {
  type = string
}

variable "logstash_beats_port" {
  type = string
}

variable "graylog_namespace" {
  type = string
}

variable "graylog_service_name" {
  type = string
}

variable "graylog_beats_port" {
  type = number
}

variable "zone_id" {
  type = string
}

variable "zone_name" {
  type = string
}

variable "chart_version" {
  type    = string
  default = "4.0.3"
}
