##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

declare -F logname >/dev/null && return


##############################################################################
# FUNCTIONS

function logname() {
    local jobname=$1
    local datetime=$(date -d "+%Y%m%d_%H:%M:%S")

    printf "%s/log/%s_%s.log" "$LOGDIR" "$jobname" "$datetime"
}


function tokenname() {
    local jobname=$1

    printf "%s/token/%s.token\n" "$WORKDIR" "$jobname"
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    logname "$@"
    tokenname "$@"
fi


# vim:ft=bash
