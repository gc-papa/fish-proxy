function __disable_proxy_apt
    if test -d "/etc/apt/apt.conf.d"
        sudo rm -rf /etc/apt/apt.conf.d/proxy.conf
    end
end
