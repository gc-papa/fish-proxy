function myip
    # Load helper functions
    source (dirname (status --current-filename))/../fish-proxy.fish
    
    __check_ip
end
