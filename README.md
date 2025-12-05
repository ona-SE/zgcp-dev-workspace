# ZGCP Dev Workspace

Development environment configured for ZGCP workflow with kubectl access, Telepresence for remocal development, Playwright for browser automation, and Claude Code for AI-assisted development.

## Features

- **Kubernetes Access**: kubectl with Okta OIDC authentication via kubelogin
- **Remocal Development**: Telepresence for intercepting cluster traffic locally
- **Browser Automation**: Playwright with Chromium for E2E testing
- **AI Development**: Claude Code CLI for AI-assisted coding
- **Container Tools**: Docker-in-Docker support
- **Package Management**: Node.js 20 and Python 3.11

## Environment Variables

Configure these as **Project Secrets** or **Organization Secrets** in Ona:

| Variable | Description | Example |
|----------|-------------|---------|
| `OKTA_CLIENT_ID` | Okta OIDC client ID for kubectl | `0oa1234...` |
| `ANTHROPIC_API_KEY` | API key for Claude Code (optional) | `sk-ant-...` |
| `ZGCP_TARGET_CLUSTER` | Target K8s cluster name | `nonprod-us-west-2` |

These are injected automatically from the MR context:

| Variable | Description |
|----------|-------------|
| `ZGCP_ZODIAC_SERVICE` | Zodiac service name |
| `ZGCP_REVIEW_NAMESPACE` | Review environment namespace |
| `MR_ID` | Merge request ID |

## Configuration Files

- `.devcontainer/devcontainer.json` - Dev container configuration with features
- `.devcontainer/setup.sh` - Post-create installation script
- `.ona/automations.yaml` - Ona automations for services and tasks

## Workflow

1. **Environment starts** → `setup-cluster-access` task runs, authenticates via Okta
2. **Telepresence daemon** connects to cluster automatically
3. **Developer runs** `start-intercept` task to route cluster traffic locally
4. **Code locally**, changes reflect immediately in review environment
5. **Run** `run-e2e-tests` to execute Playwright tests against review env

## Available Tasks

### setup-cluster-access
Configures kubectl authentication to ZGCP cluster via Okta OIDC.

```bash
gitpod automations task start setup-cluster-access
```

### start-intercept
Starts Telepresence intercept to route traffic from review environment to local process.

```bash
gitpod automations task start start-intercept
```

### run-e2e-tests
Executes Playwright tests against the review environment.

```bash
gitpod automations task start run-e2e-tests
```

## Services

### telepresence-daemon
Maintains persistent connection to ZGCP cluster. Starts automatically on environment creation.

Check status:
```bash
gitpod automations service logs telepresence-daemon
```

## Manual Commands

### Verify cluster access
```bash
kubectl cluster-info
kubectl get pods -n ${ZGCP_REVIEW_NAMESPACE}
```

### Check Telepresence status
```bash
telepresence status
telepresence list
```

### Run Playwright tests locally
```bash
export BASE_URL="https://${ZGCP_REVIEW_NAMESPACE}.review.zgcp.zillow.net"
npx playwright test
```

## Network Requirements

- **VPC Connectivity**: Ona environment requires network connectivity to ZGCP clusters (VPC peering or VPN)
- **Ports**: 8080 (service), 3000 (dev server) are forwarded by default

## Troubleshooting

### Cluster authentication fails
Check that `OKTA_CLIENT_ID` is set correctly:
```bash
echo $OKTA_CLIENT_ID
```

### Telepresence connection issues
Restart the daemon:
```bash
gitpod automations service stop telepresence-daemon
gitpod automations service start telepresence-daemon
```

### Playwright tests fail
Verify the review environment URL is accessible:
```bash
curl -I "https://${ZGCP_REVIEW_NAMESPACE}.review.zgcp.zillow.net"
```
