function __enable_proxy_git
    if test "$__FISHPROXY_GIT_PROXY_TYPE" = http
        git config --global http.proxy "$__FISHPROXY_HTTP"
        git config --global https.proxy "$__FISHPROXY_HTTP"
    else
        git config --global http.proxy "$__FISHPROXY_SOCKS5"
        git config --global https.proxy "$__FISHPROXY_SOCKS5"
    end
end
