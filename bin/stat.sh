##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

declare -F stat-sh >/dev/null && return


function stat-sh() {
    local OPTIND OPTERR OPTARG opt
    local gnuformat=()
    local bsdformat=()

    while getopts "amc" opt; do
        case "$opt" in
            a)  gnuformat+=( -c "%X" ) && bsdformat+=( -f "%a" ) ;;
            m)  gnuformat+=( -c "%Y" ) && bsdformat+=( -f "%m" ) ;;
            c)  gnuformat+=( -c "%Z" ) && bsdformat+=( -f "%c" ) ;;
        esac
    done
    shift $((OPTIND-1))

    stat "${gnuformat[@]}" "$@" 2>&1 \
    || stat "${bsdformat[@]}" "$@" 2>&1
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    stat-sh "$@"
fi


# vim:ft=bash
