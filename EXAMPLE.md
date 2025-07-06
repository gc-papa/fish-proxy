# Example configuration for fish-proxy

# After installation, run these commands:

# 1. Initialize the plugin

init_proxy

# 2. Configure proxy settings

config_proxy

# 3. Enable proxy

proxy

# 4. Check your IP

myip

# 5. Disable proxy when needed

noproxy

# 6. Uninstall (when needed)

# Complete uninstall with automatic cleanup
fish_proxy_uninstall

# Or for Fisher installations
fisher remove gc-papa/fish-proxy

# Configuration files are stored in ~/.fish-proxy/

# - status: proxy enabled/disabled status

# - http: HTTP proxy configuration

# - socks5: SOCKS5 proxy configuration

# - no_proxy: domains to exclude from proxy

# - git_proxy_type: git proxy type (http or socks5)
