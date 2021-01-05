data_dir  = "/var/nomad"

server {
  enabled          = true
  bootstrap_expect = 3
  raft_protocol    = 3
}

telemetry {
  collection_interval = "1s"
  disable_hostname = true
  prometheus_metrics = true
  publish_allocation_metrics = true
  publish_node_metrics = true
}