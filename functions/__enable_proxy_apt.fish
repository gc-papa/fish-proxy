function __enable_proxy_apt
    if test -d "/etc/apt/apt.conf.d"
        sudo touch /etc/apt/apt.conf.d/proxy.conf
        echo "Acquire::http::Proxy \"$__FISHPROXY_HTTP\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf >/dev/null
        echo "Acquire::https::Proxy \"$__FISHPROXY_HTTP\";" | sudo tee -a /etc/apt/apt.conf.d/proxy.conf >/dev/null
        echo "- apt"
    end
end
