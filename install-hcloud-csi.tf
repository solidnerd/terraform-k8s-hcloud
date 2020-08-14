resource "null_resource" "hcloud-csi" {
  count = var.csi_driver_enabled ? 1 : 0

  connection {
    host        = hcloud_server.master.0.ipv4_address
    private_key = file(var.ssh_private_key)
  }

  provisioner "file" {
    source      = "scripts/install-hcloud-csi.sh"
    destination = "/root/install-hcloud-csi.sh"
  }

  provisioner "remote-exec" {
    inline = ["HCLOUD_TOKEN=${var.hcloud_token} bash /root/install-hcloud-csi.sh"]
  }

  depends_on = [hcloud_server.master]
}

