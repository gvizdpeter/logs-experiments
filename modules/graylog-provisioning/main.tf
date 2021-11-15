resource "graylog_input" "beats" {
  title  = "beats"
  type   = "org.graylog.plugins.beats.Beats2Input"
  global = true

  attributes = jsonencode({
    bind_address          = "0.0.0.0"
    port                  = var.beats_port
    recv_buffer_size      = 1048576
    no_beats_prefix       = true
    number_worker_threads = var.graylog_replicas
    tcp_keepalive         = false
    tls_client_auth       = "disabled"
    tls_enable            = false
  })
}