#!/usr/bin/env bash
set -e

# Usage:
#   ./bootstrap-gcp.sh <instance-name> <zone> [gcp-user]
#
# Examples:
#   ./bootstrap-gcp.sh osiris-prod asia-south1-a
#   ./bootstrap-gcp.sh osiris-prod asia-south1-a rahul

INSTANCE="$1"
ZONE="$2"
GCP_USER="${3:-$(gcloud config get-value account 2>/dev/null | cut -d@ -f1)}"

if [[ -z "$INSTANCE" || -z "$ZONE" ]]; then
  echo "Usage: $0 <instance-name> <zone> [gcp-user]"
  echo "Example: $0 osiris-prod asia-south1-a"
  exit 1
fi

echo "=== Bootstrapping GCP server: $INSTANCE ($ZONE) ==="
echo "Initial GCP user: $GCP_USER"
echo ""

# Step 1: Get external IP
EXTERNAL_IP=$(gcloud compute instances describe "$INSTANCE" --zone="$ZONE" --format='get(networkInterfaces[0].accessConfigs[0].natIP)')
echo "External IP: $EXTERNAL_IP"

# Step 2: Establish initial SSH access via gcloud (injects keys via metadata)
echo "Setting up initial SSH access via gcloud..."
gcloud compute ssh "$INSTANCE" --zone="$ZONE" --ssh-flag="-o StrictHostKeyChecking=no" --command="echo connected"

# Step 3: Copy your SSH public keys to the GCP user's authorized_keys
# so Ansible can connect directly via IP afterward
YOUR_PUB_KEY="$HOME/.ssh/void.pub"
if [[ ! -f "$YOUR_PUB_KEY" ]]; then
  YOUR_PUB_KEY="$HOME/.ssh/id_ed25519.pub"
fi

echo "Injecting your public key ($YOUR_PUB_KEY)..."
gcloud compute ssh "$INSTANCE" --zone="$ZONE" --ssh-flag="-o StrictHostKeyChecking=no" --command="
  mkdir -p ~/.ssh && chmod 700 ~/.ssh
  echo '$(cat "$YOUR_PUB_KEY")' >> ~/.ssh/authorized_keys
  chmod 600 ~/.ssh/authorized_keys
  sort -u ~/.ssh/authorized_keys -o ~/.ssh/authorized_keys
"

# Step 4: Test direct SSH access via IP
echo "Testing direct SSH via IP..."
if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$GCP_USER@$EXTERNAL_IP" "echo direct-ssh-ok" 2>/dev/null; then
  echo "Direct SSH works!"
  ANSIBLE_USER="$GCP_USER"
else
  echo "Direct SSH as $GCP_USER failed — trying common GCP user names..."
  for user in debian ubuntu root; do
    if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$user@$EXTERNAL_IP" "echo ok" 2>/dev/null; then
      echo "Works as $user"
      ANSIBLE_USER="$user"
      break
    fi
  done
fi

if [[ -z "$ANSIBLE_USER" ]]; then
  echo "ERROR: Could not establish direct SSH access. Try manually:"
  echo "  gcloud compute ssh $INSTANCE --zone=$ZONE"
  exit 1
fi

echo ""
echo "=== Ready for Ansible ==="
echo "Run this:"
echo "  cd ~/dotfiles/ansible"
echo "  ansible-playbook playbooks/provision-server.yml \\"
echo "    -e \"target=$EXTERNAL_IP\" \\"
echo "    -e \"ansible_user=$ANSIBLE_USER\""
echo ""
echo "Or add to inventory/hosts.yml under debian_servers:"
echo "        $INSTANCE:"
echo "          ansible_host: $EXTERNAL_IP"
echo "          ansible_user: $ANSIBLE_USER"
