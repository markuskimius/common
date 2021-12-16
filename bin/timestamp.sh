##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

declare -F timestamp >/dev/null && return


#
# Stamp every line of input with the current time.  It uses the `ts` command if
# available, otherwise uses a custom function.
#
function timestamp() {
    local line

    if command -v ts >/dev/null; then
        ts '%Y%m%d %H:%M:%.S %z'
    else
        while IFS= read -r line; do
            printf "%s %s\n" "$(date '+%Y%m%d %H:%M:%S.%N %z')" "$line"
        done
    fi
}


#
# Stamp every line of input with the number of seconds since epoch with
# subsecond data.
#
function profile-ts() {
    local line

    if command -v ts >/dev/null; then
        ts '%.s'
    else
        while IFS= read -r line; do
            printf "%s %s\n" "$(date '+%s.%N')" "$line"
        done
    fi
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    timestamp "$@"
fi


# vim:ft=bash
