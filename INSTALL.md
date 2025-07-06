# fish-proxy Fisher Installation

This is a Fish shell plugin for proxy management, converted from the original zsh-proxy.

## Installation

```fish
fisher install /path/to/fish-proxy
```

## File Structure

- `fish-proxy.fish` - Main plugin file
- `conf.d/fish-proxy.fish` - Configuration and event handlers
- `README-fish.md` - Documentation

## Functions Provided

- `init_proxy` - Initialize plugin configuration
- `config_proxy` - Configure proxy settings
- `proxy` - Enable proxy
- `noproxy` - Disable proxy  
- `myip` - Check current IP address
- `fish_proxy_update` - Update plugin

## Configuration

The plugin stores configuration in `~/.fish-proxy/` (or `$XDG_CONFIG_HOME/.fish-proxy/`).
