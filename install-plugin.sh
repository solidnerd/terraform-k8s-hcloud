#!/bin/bash
set -eu
OS=${OS:-darwin}
HCLOUD_VERSION=${HCLOUD_VERSION:-1.1.0}
HCLOUD_TERRAFORM_URL=${HCLOUD_TERRAFORM_URL:-"https://github.com/hetznercloud/terraform-provider-hcloud/releases/download/v${HCLOUD_VERSION}/terraform-provider-hcloud_v${HCLOUD_VERSION}_${OS}_amd64.zip"}
echo "Install Terraform plugin from:"
echo "$HCLOUD_TERRAFORM_URL"
curl -sSL $HCLOUD_TERRAFORM_URL -o terraform-provider-hcloud_v${HCLOUD_VERSION}_${OS}_amd64.zip

unzip -d /tmp/terraform-provider-hcloud_v${HCLOUD_VERSION}_${OS}_amd64 terraform-provider-hcloud_v${HCLOUD_VERSION}_${OS}_amd64.zip

mkdir -p ~/.terraform.d/plugins/

mv -v /tmp/terraform-provider-hcloud_v${HCLOUD_VERSION}_${OS}_amd64/terraform-provider-hcloud ~/.terraform.d/plugins/terraform-provider-hcloud
