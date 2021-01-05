data_dir  = "/var/nomad"

client {
  enabled = true
  network_interface = "eth0"
}

telemetry {
  collection_interval = "1s"
  disable_hostname = true
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
}