#!/bin/bash

# Stop on undefined variables
set -u

# Configuration
VM_ID=8001
VM_NAME="ubuntu-2204-cloudinit-template"
STORAGE_NAME="local"
IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
IMAGE_PATH="/var/lib/vz/template/iso/jammy-server-cloudimg-amd64.img"
CLOUD_INIT_USER="localadmin "
CLOUD_INIT_PASSWORD="hackme123" # Replace with your actual password
GITHUB_USER="user" # Replace with desired GitHub username
NETWORK_BRIDGE="vmbr1" # Replace with your network bridge

# Function to download SSH keys from GitHub
download_github_keys() {
    local github_user=$1
    local keys_url="https://github.com/${github_user}.keys"
    wget -q -O - "$keys_url"
}

# Download and resize the Ubuntu image
if [ ! -f "$IMAGE_PATH" ]; then
    wget -q "$IMAGE_URL" -O "$IMAGE_PATH"
    qemu-img resize "$IMAGE_PATH" 32G
fi

# Check if the VM ID is already in use
if qm list | grep -q " $VM_ID "; then
    echo "Error: VM ID $VM_ID is already in use."
    exit 1
fi

# Create a new VM
qm create $VM_ID --name "$VM_NAME" --ostype l26 \
    --memory 1024 \
    --agent 1 \
    --bios ovmf --machine q35 --efidisk0 $STORAGE_NAME:0,pre-enrolled-keys=0 \
    --cpu host --socket 1 --cores 1 \
    --vga serial0 --serial0 socket  \
    --net0 virtio,bridge=$NETWORK_BRIDGE

# Import the downloaded image to Proxmox storage
qm importdisk $VM_ID "$IMAGE_PATH" $STORAGE_NAME

# Configure hardware settings
qm set $VM_ID --scsihw virtio-scsi-pci --virtio0 $STORAGE_NAME:$VM_ID/vm-$VM_ID-disk-1.raw,discard=on
qm set $VM_ID --boot order=virtio0
qm set $VM_ID --ide2 $STORAGE_NAME:cloudinit

# Create vendor.yaml for CloudInit
cat << EOF | sudo tee /var/lib/vz/snippets/vendor.yaml
#cloud-config
users:
  - name: smerlos
    gecos: smerlos
    groups: sudo, users, admin
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_import_id:
      - gh:smerlos
system_info:
  default_user:
    name: hack-me
    lock_passwd: false
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
random_seed:
  file: /dev/urandom
  command: ["pollinate", "-r", "-s", "https://entropy.ubuntu.com"]
  command_required: true
package_upgrade: true
packages:
  - open-vm-tools
  - build-essential
  - python3-pip
  - python3
  - vim
  - screen
  - apt-transport-https
  - ca-certificates
  - curl
  - wget
  - git
  - ack-grep
  - open-iscsi
  - ifupdown
  - resolvconf
  - qemu-guest-agent
runcmd:
  - apt update
  - apt upgrade -y
  - apt install -f -y
  - apt full-upgrade  -y
  - apt-get -y dist-upgrade -y
  - apt autoremove  -y
  - systemctl start qemu-guest-agent
power_state:
  timeout: 5
  mode: reboot
EOF

# Configuring CloudInit
qm set $VM_ID --cicustom "vendor=local:snippets/vendor.yaml,user=local:snippets/vendor.yaml,meta=local:snippets/vendor.yaml"
qm set $VM_ID --tags ubuntu-template,22.04,cloudinit

qm set $VM_ID --ipconfig0 ip=dhcp

# Convert the VM into a template
qm template $VM_ID

echo "Template $VM_NAME created successfully."
