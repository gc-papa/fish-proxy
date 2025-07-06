# Auto-load helper functions for fish-proxy
if test -d (status dirname)/../functions
    for helper in (find (status dirname)/../functions -name "__*.fish")
        source $helper
    end
end
