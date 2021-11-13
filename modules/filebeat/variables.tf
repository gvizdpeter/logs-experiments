variable "namespace" {
  type = string
}

variable "config_path" {
  type = string
}

variable "config_context" {
  type = string
}

variable "logstash_namespace" {
  type = string
}

variable "logstash_service_name" {
  type = string
}

variable "logstash_beats_port" {
  type = number
}

variable "graylog_namespace" {
  type = string
}

variable "graylog_beats_services" {
  type = list(string)
}

variable "graylog_beats_port" {
  type = number
}