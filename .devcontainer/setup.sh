#!/bin/bash
set -e

echo "🚀 Starting development environment setup..."

# ZGCP Setup
echo "📦 Installing ZGCP tools..."

# Install kubelogin for Okta OIDC authentication
echo "Installing kubelogin..."
curl -LO https://github.com/int128/kubelogin/releases/download/v1.28.1/kubelogin_linux_amd64.zip
unzip -o kubelogin_linux_amd64.zip
sudo mv kubelogin /usr/local/bin/kubectl-oidc_login
rm kubelogin_linux_amd64.zip

# Install Telepresence for remote development
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

# OnaFlix Setup
echo "📦 Installing OnaFlix tools..."

# Verify PostgreSQL client tools are installed
if ! command -v pg_isready &> /dev/null; then
    echo "❌ PostgreSQL client tools not properly installed"
    exit 1
fi

# Install jq if not present (for health checks)
if ! command -v jq &> /dev/null; then
    echo "📦 Installing jq for JSON processing..."
    sudo apt-get update && sudo apt-get install -y jq
fi

# Install nodemon globally
echo "Installing nodemon..."
npm install -g nodemon

# Make OnaFlix scripts executable
if [ -d "ona-flix" ]; then
    chmod +x ona-flix/startup.sh 2>/dev/null || true
    chmod +x ona-flix/health-check.sh 2>/dev/null || true
fi

# GitHub CLI authentication (optional)
if [ -n "$GH_CLI_TOKEN" ]; then
    gh auth login --with-token <<< "$GH_CLI_TOKEN"
    gh auth setup-git
else
    echo "ℹ️  GH_CLI_TOKEN not set, skipping authentication"
fi

echo ""
echo "🔧 Available commands:"
echo "   ZGCP:"
echo "     kubectl, helm, telepresence"
echo "   OnaFlix:"
echo "     cd ona-flix && ./startup.sh      - Start all services"
echo "     cd ona-flix && ./health-check.sh - Check service health"
echo ""
echo "✅ Setup completed successfully!"
