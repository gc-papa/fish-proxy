function __read_proxy_config
    set config_dir (test -n "$XDG_CONFIG_HOME"; and echo $XDG_CONFIG_HOME; or echo $HOME)"/.fish-proxy"
    if test -f "$config_dir/status"
        set -g __FISHPROXY_STATUS (cat "$config_dir/status")
    end
    if test -f "$config_dir/socks5"
        set -g __FISHPROXY_SOCKS5 (cat "$config_dir/socks5")
    end
    if test -f "$config_dir/http"
        set -g __FISHPROXY_HTTP (cat "$config_dir/http")
    end
    if test -f "$config_dir/no_proxy"
        set -g __FISHPROXY_NO_PROXY (cat "$config_dir/no_proxy")
    end
    if test -f "$config_dir/git_proxy_type"
        set -g __FISHPROXY_GIT_PROXY_TYPE (cat "$config_dir/git_proxy_type")
    end
end
