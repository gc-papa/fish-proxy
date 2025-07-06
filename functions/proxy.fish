function proxy
    set config_dir (test -n "$XDG_CONFIG_HOME"; and echo $XDG_CONFIG_HOME; or echo $HOME)"/.fish-proxy"
    echo "1" > "$config_dir/status"
    __enable_proxy
    __check_ip
end
