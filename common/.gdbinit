set confirm off
set verbose off
set pagination off
set history filename ~/.gdb_history
set history save
set print pretty on

set auto-load safe-path /
set exec-wrapper ~/dev-root/debesys-one/run
#set exec-wrapper /opt/debesys/edgeserver/run
#set exec-wrapper /opt/debesys/ps_blah/run

python
import sys
sys.path.insert(0, '~jason/gdb_printers/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end

