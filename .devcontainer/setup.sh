#!/bin/bash
set -e

# Install kubelogin for Okta OIDC authentication
echo "Installing kubelogin..."
curl -LO https://github.com/int128/kubelogin/releases/download/v1.28.1/kubelogin_linux_amd64.zip
unzip -o kubelogin_linux_amd64.zip
sudo mv kubelogin /usr/local/bin/kubectl-oidc_login
rm kubelogin_linux_amd64.zip

# Install Telepresence for remocal development
echo "Installing Telepresence..."
curl -fL https://app.getambassador.io/download/tel2oss/releases/download/v2.17.0/telepresence-linux-amd64 -o /tmp/telepresence
sudo install /tmp/telepresence /usr/local/bin/telepresence

# Install Playwright browsers
echo "Installing Playwright..."
npm install -g playwright
playwright install --with-deps chromium

# Install Claude Code CLI
echo "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

echo "Setup complete."
