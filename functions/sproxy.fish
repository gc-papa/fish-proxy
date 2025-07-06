# Sunrise Corporate Proxy Management
#
# This function provides enterprise proxy management for Sunrise environments
# It handles VPN connection, CNTLM proxy, certificate management, and tool configuration

function sproxy
    # Shorthand alias for sunrise_proxy
    sunrise_proxy $argv
end

# Auto-completion for sunrise_proxy
complete -c sunrise_proxy -n "__fish_use_subcommand" -a "on" -d "Enable corporate proxy and VPN"
complete -c sunrise_proxy -n "__fish_use_subcommand" -a "off" -d "Disable proxy and disconnect VPN"
complete -c sunrise_proxy -n "__fish_use_subcommand" -a "status" -d "Show current proxy status"
complete -c sunrise_proxy -n "__fish_use_subcommand" -a "trust" -d "Install Root CA certificate"

# Auto-completion for sproxy alias
complete -c sproxy -n "__fish_use_subcommand" -a "on" -d "Enable corporate proxy and VPN"
complete -c sproxy -n "__fish_use_subcommand" -a "off" -d "Disable proxy and disconnect VPN"
complete -c sproxy -n "__fish_use_subcommand" -a "status" -d "Show current proxy status"
complete -c sproxy -n "__fish_use_subcommand" -a "trust" -d "Install Root CA certificate"
