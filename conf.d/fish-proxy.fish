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
    
    echo "fish-proxy: Uninstalling plugin..."
    
    # Disable proxy if currently enabled
    if test -f "$config_dir/status"
        set status_content (cat "$config_dir/status" 2>/dev/null)
        if test "$status_content" = "1"
            echo "fish-proxy: Disabling proxy before uninstall..."
            # Disable proxy environment variables
            set -e http_proxy
            set -e HTTP_PROXY
            set -e https_proxy
            set -e HTTPS_PROXY
            set -e ftp_proxy
            set -e FTP_PROXY
            set -e rsync_proxy
            set -e RSYNC_PROXY
            set -e ALL_PROXY
            set -e all_proxy
            set -e no_proxy
        end
    end
    
    # Inform user about manual cleanup
    if test -d "$config_dir"
        echo "fish-proxy: Configuration directory still exists at: $config_dir"
        echo "fish-proxy: Run 'rm -rf $config_dir' to remove configuration files"
        echo "fish-proxy: Run 'git config --global --unset http.proxy' to reset Git proxy (if needed)"
    end
    
    echo "fish-proxy: Plugin uninstalled successfully!"
end

# Load the main plugin on shell startup
source (dirname (status --current-filename))/../fish-proxy.fish
__check_whether_init
__auto_proxy
