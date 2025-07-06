function config_proxy
    echo "===================    echo "$__read_no_proxy" > "$config_dir/no_proxy"
    echo "$__read_git_proxy_type" > "$config_dir/git_proxy_type"

    # Reload configuration
    __read_proxy_config
end=============="
    echo "Fish Proxy Plugin Config"
    echo ----------------------------------------

    echo -n "[socks5 proxy] {Default as 127.0.0.1:1080}
(address:port): "
    read __read_socks5

    echo -n "[socks5 type] Select the proxy type you want to use {Default as socks5}:
1. socks5
2. socks5h (resolve DNS through the proxy server)
(1 or 2): "
    read __read_socks5_type

    echo -n "[http proxy]   {Default as 127.0.0.1:8080}
(address:port): "
    read __read_http

    echo -n "[no proxy domain] {Default as 'localhost,127.0.0.1,localaddress,.localdomain.com'}
(comma separate domains): "
    read __read_no_proxy

    echo -n "[git proxy type] {Default as socks5}
(socks5 or http): "
    read __read_git_proxy_type
    echo "========================================"

    if test -z "$__read_socks5"
        set __read_socks5 "127.0.0.1:1080"
    end
    if test -z "$__read_socks5_type"
        set __read_socks5_type 1
    end
    if test -z "$__read_http"
        set __read_http "127.0.0.1:8080"
    end
    if test -z "$__read_no_proxy"
        set __read_no_proxy "localhost,127.0.0.1,localaddress,.localdomain.com"
    end
    if test -z "$__read_git_proxy_type"
        set __read_git_proxy_type socks5
    end

    set config_dir (test -n "$XDG_CONFIG_HOME"; and echo $XDG_CONFIG_HOME; or echo $HOME)"/.fish-proxy"
    echo "http://$__read_http" >"$config_dir/http"
    if test "$__read_socks5_type" = 2
        echo "socks5h://$__read_socks5" >"$config_dir/socks5"
    else
        echo "socks5://$__read_socks5" >"$config_dir/socks5"
    end
    echo "$__read_no_proxy" >"$config_dir/no_proxy"
    echo "$__read_git_proxy_type" >"$config_dir/git_proxy_type"

    # Reload configuration
    source (dirname (status --current-filename))/../fish-proxy.fish
    __read_proxy_config
end
