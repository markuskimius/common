##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

declare -F monitor-cpu >/dev/null && return


function monitor-cpu() {
    mpstat -o JSON | jq -j '.sysstat.hosts[0].statistics[0]."cpu-load"[0] | to_entries[] | "%", .key, ",", .value, "\n"'
}


# vim:ft=bash
