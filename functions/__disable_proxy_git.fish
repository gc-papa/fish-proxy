function __disable_proxy_git
    git config --global --unset http.proxy
    git config --global --unset https.proxy
end
