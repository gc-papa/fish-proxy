function sunrise_proxy
    if test (count $argv) -eq 0
        echo "Usage: sunrise_proxy [on|off|trust <cert-file>|status]"
        echo ""
        echo "Commands:"
        echo "  on               Enable Sunrise corporate proxy and VPN"
        echo "  off              Disable proxy and disconnect VPN"
        echo "  trust <cert>     Install Sunrise Root CA certificate"
        echo "  status           Show current proxy status"
        return 1
    end

    set -l action $argv[1]
    set -l CNTLM_HTTP_PROXY "http://127.0.0.1:3128"
    set -l CNTLM_SOCKS_PROXY "socks5://127.0.0.1:1080"
    set -l CNTLM_NO_PROXY "localhost,127.0.0.1,::1,10.*,192.168.*,.swi.srse.net"
    set -l INTERNAL_DNS "10.255.255.254"
    set -l EXTERNAL_DNS_1 "1.1.1.1"
    set -l EXTERNAL_DNS_2 "8.8.8.8"
    set -l vpn_name "Sunrise AOVPN Optional"
    set -l CERT_DIR ~/.certs
    set -l NTLM_HASHED "papa@SWI:3c5c5db3d12034413dd83d9d9832a430"

    switch $action
        case status
            echo "🔍 Sunrise Proxy Status:"
            echo "----------------------------------------"
            
            # Check VPN status
            if powershell.exe -Command "Get-VpnConnection -Name '$vpn_name'" 2>/dev/null | grep -q "Connected"
                echo "✅ VPN: Connected ($vpn_name)"
            else
                echo "❌ VPN: Disconnected"
            end
            
            # Check CNTLM status
            if pgrep -x cntlm >/dev/null
                echo "✅ CNTLM: Running"
            else
                echo "❌ CNTLM: Not running"
            end
            
            # Check proxy environment variables
            if test -n "$http_proxy"
                echo "✅ Proxy vars: Set ($http_proxy)"
            else
                echo "❌ Proxy vars: Not set"
            end
            
            # Check DNS
            set current_dns (grep "nameserver" /etc/resolv.conf 2>/dev/null | head -1 | awk '{print $2}')
            if test "$current_dns" = "$INTERNAL_DNS"
                echo "✅ DNS: Internal ($INTERNAL_DNS)"
            else
                echo "🌐 DNS: External ($current_dns)"
            end
            
            return 0

        case trust
            if test (count $argv) -ne 2
                echo "❌ Error: Please specify certificate file"
                echo "Usage: sunrise_proxy trust <cert-file>"
                return 1
            end

            set -l CERT_FILE $argv[2]
            if test ! -f $CERT_FILE
                echo "❌ Error: Certificate file '$CERT_FILE' does not exist"
                return 1
            end

            echo "🔐 Installing Sunrise Root CA from $CERT_FILE..."
            mkdir -p $CERT_DIR
            cp $CERT_FILE $CERT_DIR/sunrise-root.crt
            sudo cp $CERT_FILE /usr/local/share/ca-certificates/sunrise-root.crt
            sudo update-ca-certificates
            echo "✅ Sunrise Root CA installed successfully!"
            return 0

        case on
            echo "🚀 Enabling Sunrise Corporate Proxy..."
            echo ""
            
            # Set internal DNS
            echo "🛠 Setting internal DNS ($INTERNAL_DNS)"
            sudo rm -f /etc/resolv.conf
            echo "nameserver $INTERNAL_DNS" | sudo tee /etc/resolv.conf >/dev/null
            echo "search swi.srse.net localdomain" | sudo tee -a /etc/resolv.conf >/dev/null

            # Connect VPN
            echo "🔄 Connecting to VPN: $vpn_name..."
            powershell.exe -Command "rasdial '$vpn_name'" 2>/dev/null
            if test $status -eq 0
                echo "✅ VPN Connected: $vpn_name"
            else
                echo "⚠️ VPN connection may have failed, continuing..."
            end

            # Start CNTLM
            if not pgrep -x cntlm >/dev/null
                echo "⚠️ CNTLM not running. Starting CNTLM..."
                sudo systemctl start cntlm
                sleep 2
                if pgrep -x cntlm >/dev/null
                    echo "✅ CNTLM started successfully"
                else
                    echo "❌ Failed to start CNTLM"
                    return 1
                end
            else
                echo "✅ CNTLM already running"
            end

            # Setup certificates
            mkdir -p $CERT_DIR
            if command -q composer
                echo "🔐 Extracting certificates from proxy..."
                echo | openssl s_client -showcerts -connect repo.packagist.org:443 -proxy 127.0.0.1:3128 2>/dev/null | awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/' >$CERT_DIR/packagist.crt
                echo | openssl s_client -showcerts -connect api.github.com:443 -proxy 127.0.0.1:3128 2>/dev/null | awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/' >$CERT_DIR/github.crt

                if test -f $CERT_DIR/sunrise-root.crt
                    echo "➕ Adding Sunrise Root CA to bundle"
                    cat ~/cacert.pem $CERT_DIR/*.crt >$CERT_DIR/proxy-bundle.pem 2>/dev/null
                else
                    echo "⚠️ Sunrise Root CA missing, creating bundle without root"
                    cat ~/cacert.pem $CERT_DIR/*.crt >$CERT_DIR/proxy-bundle.pem 2>/dev/null
                end

                composer config -g cafile $CERT_DIR/proxy-bundle.pem
                echo "✅ Composer configured with certificate bundle"
            end

            # Set environment variables
            echo "🔧 Setting environment proxy variables..."
            set -gx NODE_EXTRA_CA_CERTS $CERT_DIR/proxy-bundle.pem
            set -gx NODE_OPTIONS --use-openssl-ca
            set -gx http_proxy $CNTLM_HTTP_PROXY
            set -gx https_proxy $CNTLM_HTTP_PROXY
            set -gx no_proxy $CNTLM_NO_PROXY
            set -gx all_proxy $CNTLM_SOCKS_PROXY
            set -gx NTLM_CREDENTIALS $NTLM_HASHED

            # Configure APT
            echo "📦 Configuring APT proxy..."
            echo "Acquire::http::Proxy \"$CNTLM_HTTP_PROXY\";" | sudo tee /etc/apt/apt.conf.d/80proxy >/dev/null
            echo "Acquire::https::Proxy \"$CNTLM_HTTP_PROXY\";" | sudo tee -a /etc/apt/apt.conf.d/80proxy >/dev/null
            echo "Acquire::https::Verify-Peer \"false\";" | sudo tee /etc/apt/apt.conf.d/99disable-ssl-verify >/dev/null
            echo "Acquire::https::Verify-Host \"false\";" | sudo tee -a /etc/apt/apt.conf.d/99disable-ssl-verify >/dev/null

            # Configure NPM
            if command -q npm
                echo "📦 Configuring NPM proxy..."
                npm config set proxy $CNTLM_HTTP_PROXY
                npm config set https-proxy $CNTLM_HTTP_PROXY
                npm config set cafile $CERT_DIR/proxy-bundle.pem
                npm config set strict-ssl false
                npm config set registry "https://registry.npmjs.org/"
            end

            # Configure Git
            echo "📦 Configuring Git proxy..."
            git config --global http.proxy $CNTLM_HTTP_PROXY
            git config --global https.proxy $CNTLM_HTTP_PROXY
            git config --global http.sslVerify false

            echo ""
            echo "✅ Sunrise Corporate Proxy is now ENABLED"
            echo "   Use 'sunrise_proxy status' to check configuration"

        case off
            echo "🔽 Disabling Sunrise Corporate Proxy..."
            echo ""

            # Remove environment variables
            echo "🧹 Clearing environment variables..."
            set -e http_proxy https_proxy HTTPS_PROXY no_proxy all_proxy ALL_PROXY NODE_OPTIONS NODE_EXTRA_CA_CERTS NTLM_CREDENTIALS

            # Remove APT configuration
            echo "📦 Removing APT proxy configuration..."
            sudo rm -f /etc/apt/apt.conf.d/80proxy
            sudo rm -f /etc/apt/apt.conf.d/99disable-ssl-verify

            # Reset NPM
            if command -q npm
                echo "📦 Resetting NPM configuration..."
                npm config delete proxy 2>/dev/null
                npm config delete https-proxy 2>/dev/null
                npm config delete cafile 2>/dev/null
                npm config delete strict-ssl 2>/dev/null
                npm config delete registry 2>/dev/null
            end

            # Reset Git
            echo "📦 Resetting Git configuration..."
            git config --global --unset http.proxy 2>/dev/null
            git config --global --unset https.proxy 2>/dev/null
            git config --global http.sslVerify true

            # Set external DNS
            echo "🌐 Setting external DNS ($EXTERNAL_DNS_1, $EXTERNAL_DNS_2)"
            sudo rm -f /etc/resolv.conf
            echo "nameserver $EXTERNAL_DNS_1" | sudo tee /etc/resolv.conf >/dev/null
            echo "nameserver $EXTERNAL_DNS_2" | sudo tee -a /etc/resolv.conf >/dev/null

            # Stop CNTLM
            if pgrep -x cntlm >/dev/null
                echo "🛑 Stopping CNTLM..."
                sudo systemctl stop cntlm
            end

            # Disconnect VPN
            echo "❌ Disconnecting VPN: $vpn_name..."
            powershell.exe -Command "rasdial '$vpn_name' /disconnect" 2>/dev/null

            echo ""
            echo "✅ Sunrise Corporate Proxy is now DISABLED"

        case '*'
            echo "❌ Error: Invalid command '$action'"
            echo "Use 'sunrise_proxy' without arguments to see usage"
            return 1
    end
end
