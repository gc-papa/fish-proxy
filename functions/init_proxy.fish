function init_proxy
    set config_dir (test -n "$XDG_CONFIG_HOME"; and echo $XDG_CONFIG_HOME; or echo $HOME)"/.fish-proxy"
    mkdir -p "$config_dir"
    touch "$config_dir/status"
    echo 0 >"$config_dir/status"
    touch "$config_dir/http"
    touch "$config_dir/socks5"
    touch "$config_dir/no_proxy"
    touch "$config_dir/git_proxy_type"
    echo ----------------------------------------
    echo "Great! The fish-proxy is initialized"
    echo ""
    echo '  ______ _     _     _____                       '
    echo ' |  ____(_)   | |   |  __ \                      '
    echo ' | |__   _ ___| |__ | |__) | __ _____  ___   _   '
    echo ' |  __| | / __| '"'"'_ \|  ___/ '"'"'__/ _ \ \/ | | | |  '
    echo ' | |    | \__ \ | | | |   | | | (_) >  <| |_| |  '
    echo ' |_|    |_|___/_| |_|_|   |_|  \___/_/\_\\__, |  '
    echo '                                         __/ |  '
    echo '                                        |___/   '
    echo ----------------------------------------
    echo "Now you might want to run following command:"
    echo "\$ config_proxy"
    echo ----------------------------------------
end
