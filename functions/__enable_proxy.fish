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
