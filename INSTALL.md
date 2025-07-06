# fish-proxy Fisher Installation

This is a Fish shell plugin for proxy management, converted from the original zsh-proxy.

## Installation

```fish
fisher install /path/to/fish-proxy
```

## Uninstallation

### Fisher

```fish
fisher remove gc-papa/fish-proxy
```

### Manual

```fish
# Remove plugin files
rm -rf ~/.config/fish/plugins/fish-proxy

# Remove configuration files
rm -rf ~/.fish-proxy
```

### Complete Cleanup

For complete removal:

1. **Disable proxy first** (if currently enabled):
   ```fish
   noproxy
   ```

2. **Remove all configuration files**:
   ```fish
   rm -rf ~/.fish-proxy
   # or if using XDG_CONFIG_HOME:
   rm -rf $XDG_CONFIG_HOME/.fish-proxy
   ```

3. **Reset Git proxy settings** (if needed):
   ```fish
   git config --global --unset http.proxy
   git config --global --unset https.proxy
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
