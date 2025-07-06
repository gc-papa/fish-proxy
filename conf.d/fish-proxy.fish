function _fish_proxy_install --on-event fish_proxy_install
    # Create configuration directory on install
    set config_dir (test -n "$XDG_CONFIG_HOME"; and echo $XDG_CONFIG_HOME; or echo $HOME)"/.fish-proxy"
    if not test -d "$config_dir"
        echo "fish-proxy: Creating configuration directory..."
        mkdir -p "$config_dir"
    end
end

function _fish_proxy_update --on-event fish_proxy_update
    # Handle updates
    echo "fish-proxy: Plugin updated!"
end

function _fish_proxy_uninstall --on-event fish_proxy_uninstall
    # Clean up on uninstall
    set config_dir (test -n "$XDG_CONFIG_HOME"; and echo $XDG_CONFIG_HOME; or echo $HOME)"/.fish-proxy"
    if test -d "$config_dir"
        echo "fish-proxy: Cleaning up configuration..."
        echo "Run 'rm -rf $config_dir' to remove configuration files"
    end
end
