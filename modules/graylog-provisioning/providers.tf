provider "graylog" {
  web_endpoint_uri = "http://${var.graylog_host}/api"
  api_version      = var.api_version
  auth_name        = var.graylog_username
  auth_password    = var.graylog_password
}
