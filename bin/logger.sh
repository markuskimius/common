##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

declare -F logger >/dev/null && return


##############################################################################
# GLOBALS

LOGGER_ENABLE=${LOGGER_ENABLE-INFO WARNING ERROR}


##############################################################################
# FUNCTIONS

function logger() {
    local level=$1 && shift
    local is_enabled=0

    # Log only if the log level is enabled
    if [[ " $LOGGER_ENABLE " == *" $level "* ]]; then
        is_enabled=1
    fi

    # Print header
    if (( is_enabled )); then
        printf "LOGGER %s on %s at %s:%s in %s():\n" "$level" "$(date "+%Y%m%d %H:%M:%S.%N %Z")" "${BASH_SOURCE[1]-(none)}" "${BASH_LINENO[0]-0}" "${FUNCNAME[1]-main}"
    fi

    # Print arguments or stdin
    if   (( is_enabled && $# )); then
        printf "%s\n" "$@"
        echo
    elif (( is_enabled )); then
        cat
        echo
    elif (( $# == 0 )); then
        # Not enabled but we're supposed to read from stdin -> consume stdin
        cat >/dev/null
    fi
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    logger "$@"
fi


# vim:ft=bash
