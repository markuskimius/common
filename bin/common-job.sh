##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

declare -F tokenname >/dev/null && return


##############################################################################
# FUNCTIONS

function tokenname() {
    local jobname=$1

    printf "%s/token/%s.token\n" "$WORKDIR" "$jobname"
}


function logname() {
    local jobname=$1
    local datetime=$(date "+%Y%m%d_%H:%M:%S")

    printf "%s/log/%s_%s.log" "$WORKDIR" "$jobname" "$datetime"
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    tokenname "$@"
    logname "$@"
fi


# vim:ft=bash
