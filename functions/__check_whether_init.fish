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
