resource "hcloud_server" "node" {
  count       = var.node_count
  name        = "node-${count.index + 1}"
  server_type = "${var.node_type}"
  image       = "${var.node_image}"
  ssh_keys    = ["${hcloud_ssh_key.k8s_admin.id}"]

  connection {
    host        = self.ipv4_address
    private_key = file(var.ssh_private_key)
  }

  provisioner "file" {
    source      = "files/10-kubeadm.conf"
    destination = "/root/10-kubeadm.conf"
  }

  provisioner "file" {
    source      = "scripts/bootstrap.sh"
    destination = "/root/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = ["DOCKER_VERSION=${var.docker_version} KUBERNETES_VERSION=${var.kubernetes_version} bash /root/bootstrap.sh"]
  }
}

resource "null_resource" "install_node" {
  count = var.node_count

  connection {
    host        = element(hcloud_server.node.*.ipv4_address, count.index)
    private_key = file(var.ssh_private_key)
  }

  provisioner "file" {
    source      = "${path.module}/secrets/kubeadm_join"
    destination = "/tmp/kubeadm_join"
  }

  provisioner "file" {
    source      = "scripts/node.sh"
    destination = "/root/node.sh"
  }

  provisioner "remote-exec" {
    inline = ["bash /root/node.sh"]
  }

  depends_on = [
    "hcloud_server_network.nodes",
    "null_resource.install_master"
  ]
}