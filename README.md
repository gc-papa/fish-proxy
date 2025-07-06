# fish-proxy

[![License](https://img.shields.io/github/license/gc-papa/fish-proxy.svg?style=flat-square)](./LICENSE)
[![Fish Shell](https://img.shields.io/badge/fish-shell-blue.svg?style=flat-square)](https://fishshell.com/)
[![Fisher](https://img.shields.io/badge/fisher-compatible-green.svg?style=flat-square)](https://github.com/jorgebucaran/fisher)

🐟 A Fish shell plugin to configure proxy for package managers and software.

**This is a Fish shell conversion of the original [zsh-proxy](https://github.com/sukkaw/zsh-proxy) plugin by [Sukka](https://github.com/SukkaW).**

## Features

- 🔧 Easy proxy configuration with interactive setup
- 🌐 Support for HTTP, HTTPS, SOCKS5, and SOCKS5h proxies
- 📦 Automatic proxy configuration for: Git, NPM, Yarn, PNPM, APT
- 🔍 IP checking to verify proxy status
- 🎣 Fisher compatible installation
- 🐠 Native Fish shell syntax and conventions

## Installation

### Using Fisher (Recommended)

```fish
fisher install gc-papa/fish-proxy
```

### Manual Installation

1. Clone this repository:

```fish
git clone https://github.com/gc-papa/fish-proxy.git ~/.config/fish/plugins/fish-proxy
```

2. Add to your `~/.config/fish/config.fish`:

```fish
source ~/.config/fish/plugins/fish-proxy/fish-proxy.fish
```

## Quick Start

After installation, open a new terminal and you'll see:

```
----------------------------------------
You should run following command first:
$ init_proxy
----------------------------------------
```

### 1. Initialize the plugin

```fish
init_proxy
```

### 2. Configure proxy settings

```fish
config_proxy
```

You'll be prompted to enter:

- SOCKS5 proxy (default: 127.0.0.1:1080)
- SOCKS5 type (socks5 or socks5h)
- HTTP proxy (default: 127.0.0.1:8080)
- No proxy domains (default: localhost,127.0.0.1,localaddress,.localdomain.com)
- Git proxy type (socks5 or http)

### 3. Enable proxy

```fish
proxy
```

### 4. Check your IP

```fish
myip
```

### 5. Disable proxy when needed

```fish
noproxy
```

## Commands

| Command                | Description                              |
| ---------------------- | ---------------------------------------- |
| `init_proxy`           | Initialize plugin configuration          |
| `config_proxy`         | Configure proxy settings interactively   |
| `proxy`                | Enable proxy for all supported tools     |
| `noproxy`              | Disable proxy for all supported tools    |
| `myip`                 | Check current IP address and location    |
| `fish_proxy_update`    | Update plugin (for manual installations) |
| `fish_proxy_uninstall` | Complete manual uninstall with cleanup   |

## Supported Tools

fish-proxy automatically configures proxy for:

- **Environment variables**: `http_proxy`, `https_proxy`, `ftp_proxy`, `rsync_proxy`, `all_proxy`, `no_proxy`
- **Git**: HTTP/HTTPS repository operations
- **NPM**: Package installation and registry access
- **Yarn**: Package management
- **PNPM**: Package management
- **APT**: Package manager (Linux)

## Configuration

Configuration files are stored in `~/.fish-proxy/` (or `$XDG_CONFIG_HOME/.fish-proxy/`):

- `status`: Proxy enabled/disabled status
- `http`: HTTP proxy configuration
- `socks5`: SOCKS5 proxy configuration
- `no_proxy`: Domains to exclude from proxy
- `git_proxy_type`: Git proxy type (http or socks5)

## Automatic Proxy

When enabled, fish-proxy will automatically set proxy environment variables each time you open a new terminal session.

## Uninstallation

### Fisher

```fish
fisher remove gc-papa/fish-proxy
```

### Manual

```fish
# Option 1: Use the built-in uninstall function
fish_proxy_uninstall

# Option 2: Manual removal
rm -rf ~/.config/fish/plugins/fish-proxy
rm -rf ~/.fish-proxy
```

### Complete Cleanup

The `fish_proxy_uninstall` function will automatically:

- Disable current proxy settings
- Remove configuration files
- Reset Git proxy settings
- Clean up package manager proxy settings
- Provide instructions for APT proxy removal (requires sudo)

## Differences from zsh-proxy

- 🐠 Native Fish shell syntax and functions
- 🎣 Fisher package manager compatibility
- 🔧 XDG Base Directory specification support
- 📁 Configuration stored in `~/.fish-proxy/` instead of `~/.zsh-proxy/`
- 🔄 Fish-specific variable management (`set -gx` instead of `export`)

## Troubleshooting

### Functions not found after installation

If you get "command not found" errors after installing with Fisher, try:

```fish
# Manual reload of helper functions
for helper in ~/.config/fish/functions/__*.fish
    source $helper 2>/dev/null
end
```

### Proxy authentication issues

If you're behind a corporate proxy, `myip` might show authentication pages. This is normal - the plugin detects your network environment correctly.

### Network connectivity issues

The `myip` function requires internet access to external IP services. If you're in a restricted network, this command might timeout or fail.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

MIT License - see [LICENSE](./LICENSE) file for details.

## Credits

- **Original zsh-proxy**: [Sukka](https://github.com/SukkaW) - [zsh-proxy](https://github.com/sukkaw/zsh-proxy)
- **Fish conversion**: [gc-papa](https://github.com/gc-papa)

## Acknowledgments

- Thanks to [Sukka](https://github.com/SukkaW) for the original zsh-proxy plugin
- Thanks to the Fish shell community for the excellent documentation
- Thanks to [jorgebucaran](https://github.com/jorgebucaran) for Fisher

---

**🐟 Happy fishing with proxies!**
