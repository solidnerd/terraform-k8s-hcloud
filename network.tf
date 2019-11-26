resource "hcloud_network" "privateNet" {
  name     = "k8s-net"
  ip_range = "10.0.1.0/16"
}
resource "hcloud_network_subnet" "k8ssubnet" {
  network_id   = hcloud_network.privateNet.id
  type         = "server"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}
resource "hcloud_server_network" "masters" {
  count      = var.master_count
  server_id  = element(hcloud_server.master.*.id, count.index)
  network_id = hcloud_network.privateNet.id
}
resource "hcloud_server_network" "nodes" {
  count      = var.node_count
  server_id  = element(hcloud_server.node.*.id, count.index)
  network_id = hcloud_network.privateNet.id
}