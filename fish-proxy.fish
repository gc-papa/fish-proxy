#!/usr/bin/env fish
#  ______ _____ _    _   _____
# |___  // ____| |  | | |  __ \
#    / /| (___ | |__| | | |__| ) __ _____  ___   _
#   / /  \___ \|  __  | |  ___/ '__/ _ \ \/ | | | |
#  / /__ ____) | |  | | | |   | | | (_) >  <| |_| |
# /_____|_____/|_|  |_| |_|   |_|  \___/_/\_\\__, |
#                                             __/ |
#                                            |___/
# -------------------------------------------------
# fish-proxy - A proxy plugin for fish shell
#
# Original zsh-proxy by Sukka (https://skk.moe)
# Fish conversion by gc-papa (https://github.com/gc-papa)
#
# Repository: https://github.com/gc-papa/fish-proxy
# License: MIT

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
        echo ----------------------------------------
        echo "You should run following command first:"
        echo "\$ init_proxy"
        echo ----------------------------------------
    else
        __read_proxy_config
    end
end

function __check_ip
    echo "========================================"
    echo "Check what your IP is"
    echo ----------------------------------------
    set ipv4 (curl -s -k https://api-ipv4.ip.sb/ip -H 'user-agent: fish-proxy')
    if test -n "$ipv4"
        echo "IPv4: $ipv4"
    else
        echo "IPv4: -"
    end
    echo ----------------------------------------
    set ipv6 (curl -s -k -m10 https://api-ipv6.ip.sb/ip -H 'user-agent: fish-proxy')
    if test -n "$ipv6"
        echo "IPv6: $ipv6"
    else
        echo "IPv6: -"
    end
    if command -v python >/dev/null
        set geoip (curl -s -k https://api.ip.sb/geoip -H 'user-agent: fish-proxy')
        if test -n "$geoip"
            echo ----------------------------------------
            echo "Info: "
            echo $geoip | python -m json.tool
        end
    end
    echo "========================================"
end

function __config_proxy
    echo "========================================"
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

    __read_proxy_config
end

# ==================================================

# Proxy for APT

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

# Proxy for pip
# pip can read http_proxy & https_proxy

# Proxy for terminal

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

# Proxy for Git

function __enable_proxy_git
    if test "$__FISHPROXY_GIT_PROXY_TYPE" = http
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

# Clone with SSH can be found at https://github.com/comwrg/FUCK-GFW#git

# NPM

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

# ==================================================

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
        echo ----------------------------------------
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
    if test "$__FISHPROXY_STATUS" = 1
        __enable_proxy_all
    end
end

function __fish_proxy_update
    set current_dir (pwd)
    if test -d "$HOME/.config/fish/conf.d"
        cd "$HOME/.config/fish/conf.d"
        if test -d fish-proxy
            cd fish-proxy
            git fetch --all
            git reset --hard origin/main
        end
    end
    cd "$current_dir"
end

# ==================================================

function init_proxy
    set config_dir (test -n "$XDG_CONFIG_HOME"; and echo $XDG_CONFIG_HOME; or echo $HOME)"/.fish-proxy"
    mkdir -p "$config_dir"
    touch "$config_dir/status"
    echo 0 >"$config_dir/status"
    touch "$config_dir/http"
    touch "$config_dir/socks5"
    touch "$config_dir/no_proxy"
    touch "$config_dir/git_proxy_type"
    echo ----------------------------------------
    echo "Great! The fish-proxy is initialized"
    echo ""
    echo '  ______ _____ _    _   _____  '
    echo ' |___  // ____| |  | | |  __ \ '
    echo '    / /| (___ | |__| | | |__| ) __ _____  ___   _ '
    echo '   / /  \___ \|  __  | |  ___/ '"'"'__/ _ \ \/ | | | |'
    echo '  / /__ ____) | |  | | | |   | | | (_) >  <| |_| |'
    echo ' /_____|_____/|_|  |_| |_|   |_|  \___/_/\_\\__, |'
    echo '                                             __/ |'
    echo '                                            |___/ '
    echo ----------------------------------------
    echo "Now you might want to run following command:"
    echo "\$ config_proxy"
    echo ----------------------------------------
end

function config_proxy
    __config_proxy
end

function proxy
    set config_dir (test -n "$XDG_CONFIG_HOME"; and echo $XDG_CONFIG_HOME; or echo $HOME)"/.fish-proxy"
    echo 1 >"$config_dir/status"
    __enable_proxy
    __check_ip
end

function noproxy
    set config_dir (test -n "$XDG_CONFIG_HOME"; and echo $XDG_CONFIG_HOME; or echo $HOME)"/.fish-proxy"
    echo 0 >"$config_dir/status"
    __disable_proxy
    __check_ip
end

function myip
    __check_ip
end

function fish_proxy_update
    __fish_proxy_update
end

function fish_proxy_uninstall
    echo "========================================"
    echo "fish-proxy Manual Uninstall"
    echo "========================================"
    
    # Disable proxy first
    echo "Disabling proxy..."
    __disable_proxy
    
    # Remove configuration
    set config_dir (test -n "$XDG_CONFIG_HOME"; and echo $XDG_CONFIG_HOME; or echo $HOME)"/.fish-proxy"
    if test -d "$config_dir"
        echo "Removing configuration directory: $config_dir"
        rm -rf "$config_dir"
    end
    
    # Reset git proxy settings
    echo "Resetting Git proxy settings..."
    git config --global --unset http.proxy 2>/dev/null
    git config --global --unset https.proxy 2>/dev/null
    
    # Clean up package manager settings
    echo "Cleaning up package manager proxy settings..."
    if command -v npm >/dev/null
        npm config delete proxy 2>/dev/null
        npm config delete https-proxy 2>/dev/null
    end
    if command -v yarn >/dev/null
        yarn config delete proxy 2>/dev/null
        yarn config delete https-proxy 2>/dev/null
    end
    if command -v pnpm >/dev/null
        pnpm config delete proxy 2>/dev/null
        pnpm config delete https-proxy 2>/dev/null
    end
    
    # Remove APT proxy configuration (requires sudo)
    if test -f "/etc/apt/apt.conf.d/proxy.conf"
        echo "APT proxy configuration found. Run the following command to remove it:"
        echo "sudo rm -f /etc/apt/apt.conf.d/proxy.conf"
    end
    
    echo "========================================"
    echo "fish-proxy uninstalled successfully!"
    echo "You can now remove the plugin files manually if needed."
    echo "========================================"
end

# Initialize on load
__check_whether_init
__auto_proxy
