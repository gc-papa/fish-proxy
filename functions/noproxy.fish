function noproxy
    # Load helper functions
    source (dirname (status --current-filename))/../fish-proxy.fish
    
    set config_dir (test -n "$XDG_CONFIG_HOME"; and echo $XDG_CONFIG_HOME; or echo $HOME)"/.fish-proxy"
    echo "0" > "$config_dir/status"
    __disable_proxy
    __check_ip
end
