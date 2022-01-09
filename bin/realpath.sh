##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

declare -F realpath-sh >/dev/null && return


function realpath-sh() {
    local last=""
    local next=$1

    # Use realpath or readlink -f if available
    if command -v realpath >/dev/null; then
        realpath "$next"
        return $?
    elif command -v readlink >/dev/null; then
        readlink -f "$next" 2>/dev/null
        return $?
    fi

    # Manual
    while [[ "$next" != "$last" ]]; do
        local realname=$(readlink "$next" || basename "$next")
        local realdir=$(cd "$(dirname "$next")" && pwd -P)
        local realfull="${realdir}/${realname}"

        # Validate
        [[ -n "$realdir" && -n "$realname" ]] || realfull=""
        [[ -e "$realfull" ]] || realfull=""

        last=$next
        next=$realfull
    done

    printf "%s" "$last"
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    realpath-sh "$@"
fi


# vim:ft=bash
