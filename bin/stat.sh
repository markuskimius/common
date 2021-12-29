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
    local gnuformat=""
    local bsdformat=""

    while getopts "nugamc" opt; do
        case "$opt" in
            n)  gnuformat+=" %n" && bsdformat+=" %N" ;;
            u)  gnuformat+=" %U" && bsdformat+=" %u" ;;
            g)  gnuformat+=" %G" && bsdformat+=" %g" ;;
            a)  gnuformat+=" %X" && bsdformat+=" %a" ;;
            m)  gnuformat+=" %Y" && bsdformat+=" %m" ;;
            c)  gnuformat+=" %Z" && bsdformat+=" %c" ;;
        esac
    done
    shift $((OPTIND-1))

    stat -c "${gnuformat:1}" "$@" 2>&1 \
    || stat -f "${bsdformat:1}" "$@" 2>&1
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    stat-sh "$@"
fi


# vim:ft=bash
