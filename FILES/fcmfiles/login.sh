#!/bin/sh
/usr/bin/fwx_cli.sh
[ "$(uci -q get system.@system[0].ttylogin)" = 1 ] || exec /bin/ash --login

exec /bin/login
