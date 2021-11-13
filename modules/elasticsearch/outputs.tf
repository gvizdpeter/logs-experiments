output "elasticsearch_address" {
  value = aws_elasticsearch_domain.logs.endpoint
}

output "elasticsearch_username" {
  value = random_password.elasticsearch_master_password.keepers["username"]
  depends_on = [
    aws_elasticsearch_domain.logs,
  ]
}

output "elasticsearch_password" {
  value = random_password.elasticsearch_master_password.result
  depends_on = [
    aws_elasticsearch_domain.logs,
  ]
}