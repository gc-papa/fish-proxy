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
