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
