# fish-proxy helper functions
# These functions are automatically loaded by Fisher

# Global variables
set -g __FISHPROXY_STATUS ""
set -g __FISHPROXY_SOCKS5 ""
set -g __FISHPROXY_HTTP ""
set -g __FISHPROXY_NO_PROXY ""
set -g __FISHPROXY_GIT_PROXY_TYPE ""

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

function __check_whether_init
    set config_dir (test -n "$XDG_CONFIG_HOME"; and echo $XDG_CONFIG_HOME; or echo $HOME)"/.fish-proxy"
    if not test -f "$config_dir/status"; or not test -f "$config_dir/http"; or not test -f "$config_dir/socks5"; or not test -f "$config_dir/no_proxy"
        echo "----------------------------------------"
        echo "You should run following command first:"
        echo "\$ init_proxy"
        echo "----------------------------------------"
    else
        __read_proxy_config
    end
end

function __check_ip
    echo "========================================"
    echo "Check what your IP is"
    echo "----------------------------------------"
    set ipv4 (curl -s -k https://api-ipv4.ip.sb/ip -H 'user-agent: fish-proxy')
    if test -n "$ipv4"
        echo "IPv4: $ipv4"
    else
        echo "IPv4: -"
    end
    echo "----------------------------------------"
    set ipv6 (curl -s -k -m10 https://api-ipv6.ip.sb/ip -H 'user-agent: fish-proxy')
    if test -n "$ipv6"
        echo "IPv6: $ipv6"
    else
        echo "IPv6: -"
    end
    if command -v python >/dev/null
        set geoip (curl -s -k https://api.ip.sb/geoip -H 'user-agent: fish-proxy')
        if test -n "$geoip"
            echo "----------------------------------------"
            echo "Info: "
            echo $geoip | python -m json.tool
        end
    end
    echo "========================================"
end

function __enable_proxy_apt
    if test -d "/etc/apt/apt.conf.d"
        sudo touch /etc/apt/apt.conf.d/proxy.conf
        echo "Acquire::http::Proxy \"$__FISHPROXY_HTTP\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf >/dev/null
        echo "Acquire::https::Proxy \"$__FISHPROXY_HTTP\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf >/dev/null
        echo "- apt"
    end
end

function __disable_proxy_apt
    if test -d "/etc/apt/apt.conf.d"
        sudo rm -rf /etc/apt/apt.conf.d/proxy.conf
    end
end

function __enable_proxy_all
    # http_proxy
    set -gx http_proxy "$__FISHPROXY_HTTP"
    set -gx HTTP_PROXY "$__FISHPROXY_HTTP"
    # https_proxy
    set -gx https_proxy "$__FISHPROXY_HTTP"
    set -gx HTTPS_PROXY "$__FISHPROXY_HTTP"
    # ftp_proxy
    set -gx ftp_proxy "$__FISHPROXY_HTTP"
    set -gx FTP_PROXY "$__FISHPROXY_HTTP"
    # rsync_proxy
    set -gx rsync_proxy "$__FISHPROXY_HTTP"
    set -gx RSYNC_PROXY "$__FISHPROXY_HTTP"
    # all_proxy
    set -gx ALL_PROXY "$__FISHPROXY_SOCKS5"
    set -gx all_proxy "$__FISHPROXY_SOCKS5"

    set -gx no_proxy "$__FISHPROXY_NO_PROXY"
end

function __disable_proxy_all
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

function __enable_proxy_git
    if test "$__FISHPROXY_GIT_PROXY_TYPE" = "http"
        git config --global http.proxy "$__FISHPROXY_HTTP"
        git config --global https.proxy "$__FISHPROXY_HTTP"
    else
        git config --global http.proxy "$__FISHPROXY_SOCKS5"
        git config --global https.proxy "$__FISHPROXY_SOCKS5"
    end
end

function __disable_proxy_git
    git config --global --unset http.proxy
    git config --global --unset https.proxy
end

function __enable_proxy_npm
    if command -v npm >/dev/null
        npm config set proxy "$__FISHPROXY_HTTP"
        npm config set https-proxy "$__FISHPROXY_HTTP"
        echo "- npm"
    end
    if command -v yarn >/dev/null
        yarn config set proxy "$__FISHPROXY_HTTP" >/dev/null 2>&1
        yarn config set https-proxy "$__FISHPROXY_HTTP" >/dev/null 2>&1
        echo "- yarn"
    end
    if command -v pnpm >/dev/null
        pnpm config set proxy "$__FISHPROXY_HTTP" >/dev/null 2>&1
        pnpm config set https-proxy "$__FISHPROXY_HTTP" >/dev/null 2>&1
        echo "- pnpm"
    end
end

function __disable_proxy_npm
    if command -v npm >/dev/null
        npm config delete proxy
        npm config delete https-proxy
    end
    if command -v yarn >/dev/null
        yarn config delete proxy >/dev/null 2>&1
        yarn config delete https-proxy >/dev/null 2>&1
    end
    if command -v pnpm >/dev/null
        pnpm config delete proxy >/dev/null 2>&1
        pnpm config delete https-proxy >/dev/null 2>&1
    end
end

function __enable_proxy
    if test -z "$__FISHPROXY_STATUS"; or test -z "$__FISHPROXY_SOCKS5"; or test -z "$__FISHPROXY_HTTP"
        echo "========================================"
        echo "fish-proxy can not read configuration."
        echo "You may have to reinitialize and reconfigure the plugin."
        echo "Use following commands would help:"
        echo "\$ init_proxy"
        echo "\$ config_proxy"
        echo "\$ proxy"
        echo "========================================"
    else
        echo "========================================"
        echo -n "Resetting proxy... "
        __disable_proxy_all
        __disable_proxy_git
        __disable_proxy_npm
        __disable_proxy_apt
        echo "Done!"
        echo "----------------------------------------"
        echo "Enable proxy for:"
        echo "- shell"
        __enable_proxy_all
        echo "- git"
        __enable_proxy_git
        # npm & yarn & pnpm
        __enable_proxy_npm
        # apt
        __enable_proxy_apt
        echo "Done!"
    end
end

function __disable_proxy
    __disable_proxy_all
    __disable_proxy_git
    __disable_proxy_npm
    __disable_proxy_apt
end

function __auto_proxy
    if test "$__FISHPROXY_STATUS" = "1"
        __enable_proxy_all
    end
end
