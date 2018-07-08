output "node_ips" {
  value = ["${hcloud_server.node.*.ipv4_address}"]
}

output "master_ips" {
  value = ["${hcloud_server.master.*.ipv4_address}"]
}
