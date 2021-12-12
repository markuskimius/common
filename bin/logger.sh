##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

declare -F logger >/dev/null && exit

source "colorize.sh" || exit 1


##############################################################################
# GLOBALS

LOGGER_INDENT=0


##############################################################################
# FUNCTIONS

function logger() {
    local level=$1 && shift
    local line

    # Print arguments or stdin.
    while IFS= read -r line; do
        line=$(printf "%*s[%4s] %s" "$LOGGER_INDENT" "" "${level::4}" "$line")

        case "$level" in
            GOOD)   colorize green  "$line" 1      ;;
            WARN)   colorize yellow "$line" 2 1>&2 ;;
            FAIL)   colorize red    "$line" 2 1>&2 ;;
            *)      printf "%s\n" "$line" ;;
        esac
    done < <( (( $# )) && printf "%s\n" "$@" || cat )
}


function logger-push() {
    local count=${1-1}

    (( LOGGER_INDENT += 2 * count )) || :
}


function logger-pop() {
    local count=${1-1}

    (( LOGGER_INDENT -= 2 * count )) || :
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    logger "$@"
fi


# vim:ft=bash
