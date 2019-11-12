resource "null_resource" "calico" {
  count = var.calico_enabled ? 1 : 0

  connection {
    host        = hcloud_server.master.0.ipv4_address
    private_key = file(var.ssh_private_key)
  }

  provisioner "remote-exec" {
    inline = ["kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml"]
  }

  depends_on = ["hcloud_server.master"]
}

