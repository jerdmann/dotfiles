set confirm off
set verbose off
set pagination off
set history filename ~/.gdb_history
set history save
set print pretty on

# nice debug info on breakpoints
define hook
    commands
    thr
    bt
    end
end

set auto-load safe-path /
set exec-wrapper ~/dev-root/debesys-one/run
#set exec-wrapper /opt/debesys/edgeserver/run
#set exec-wrapper /opt/debesys/ps_blah/run
