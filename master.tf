resource "hcloud_server" "master" {
  count       = var.master_count
  name        = "master-${count.index + 1}"
  server_type = "${var.master_type}"
  image       = "${var.master_image}"
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

resource "null_resource" "install_master" {
  count = var.master_count

  connection {
    host        = element(hcloud_server.master.*.ipv4_address, count.index)
    private_key = file(var.ssh_private_key)
  }
  provisioner "file" {
    source      = "scripts/master.sh"
    destination = "/root/master.sh"
  }

  provisioner "remote-exec" {
    inline = "FEATURE_GATES=${var.feature_gates} bash /root/master.sh"
  }

  provisioner "local-exec" {
    command = "bash scripts/copy-kubeadm-token.sh"

    environment = {
      SSH_PRIVATE_KEY = file(var.ssh_private_key)
      SSH_USERNAME    = "root"
      SSH_HOST        = hcloud_server.master[0].ipv4_address
      TARGET          = "${path.module}/secrets/"
    }
  }
  depends_on = ["hcloud_server_network.masters"]
}
