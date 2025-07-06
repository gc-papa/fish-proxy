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
