# Sunrise Corporate Proxy Manager

## Overview
`sunrise_proxy` is a comprehensive corporate proxy management tool designed for Sunrise enterprise environments. It handles VPN connections, CNTLM proxy configuration, certificate management, and tool-specific proxy settings.

## Usage

```fish
sunrise_proxy [command] [options]
```

### Commands

#### `sunrise_proxy on`
Enables the complete corporate proxy setup:
- 🔄 Connects to Sunrise VPN
- 🛠 Sets internal DNS (10.255.255.254)
- ⚡ Starts CNTLM service
- 🔐 Configures certificates for HTTPS
- 📦 Sets up proxy for: NPM, Git, APT, Composer
- 🌐 Configures environment variables

#### `sunrise_proxy off`
Disables the corporate proxy setup:
- ❌ Disconnects VPN
- 🌐 Sets external DNS (1.1.1.1, 8.8.8.8)
- 🛑 Stops CNTLM service
- 🧹 Clears all proxy configurations
- 📦 Resets tool configurations

#### `sunrise_proxy status`
Shows current proxy status:
- VPN connection status
- CNTLM service status
- Environment variables
- DNS configuration

#### `sunrise_proxy trust <cert-file>`
Installs Sunrise Root CA certificate:
- 📋 Copies certificate to system trust store
- 🔄 Updates CA certificates
- 💾 Stores certificate for bundle creation

### Aliases

- `sproxy` - Short alias for `sunrise_proxy`

### Examples

```fish
# Enable corporate proxy
sunrise_proxy on

# Check status
sunrise_proxy status
sproxy status

# Disable proxy
sunrise_proxy off

# Install certificate
sunrise_proxy trust ~/Downloads/sunrise-root.crt
```

## Configuration

The function uses these default settings:

| Setting | Value |
|---------|-------|
| HTTP Proxy | http://127.0.0.1:3128 |
| SOCKS Proxy | socks5://127.0.0.1:1080 |
| Internal DNS | 10.255.255.254 |
| External DNS | 1.1.1.1, 8.8.8.8 |
| VPN Name | "Sunrise AOVPN Optional" |
| Certificate Dir | ~/.certs |

## Supported Tools

The function automatically configures proxy for:

- **Environment variables**: `http_proxy`, `https_proxy`, `all_proxy`, `no_proxy`
- **Git**: Global proxy configuration
- **NPM**: Registry and proxy settings
- **APT**: Package manager proxy
- **Composer**: PHP dependency manager
- **Node.js**: Extra CA certificates

## Requirements

- Fish shell
- CNTLM proxy server
- PowerShell (for VPN management)
- sudo access (for system configuration)

## Integration with fish-proxy

This tool is designed to work alongside the generic `fish-proxy` plugin:

- `fish-proxy`: Generic proxy management
- `sunrise_proxy`: Corporate-specific proxy management

Both can coexist without conflicts.
