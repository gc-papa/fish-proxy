function __check_ip
    echo "========================================"
    echo "Check what your IP is"
    echo ----------------------------------------
    set ipv4 (curl -s -k https://api-ipv4.ip.sb/ip -H 'user-agent: fish-proxy')
    if test -n "$ipv4"
        echo "IPv4: $ipv4"
    else
        echo "IPv4: -"
    end
    echo ----------------------------------------
    set ipv6 (curl -s -k -m10 https://api-ipv6.ip.sb/ip -H 'user-agent: fish-proxy')
    if test -n "$ipv6"
        echo "IPv6: $ipv6"
    else
        echo "IPv6: -"
    end
    if command -v python >/dev/null
        set geoip (curl -s -k https://api.ip.sb/geoip -H 'user-agent: fish-proxy')
        if test -n "$geoip"
            echo ----------------------------------------
            echo "Info: "
            echo $geoip | python -m json.tool
        end
    end
    echo "========================================"
end
