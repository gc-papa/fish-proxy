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
