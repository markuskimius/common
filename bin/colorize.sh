##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

declare -F colorize >/dev/null && exit


function colorize() {
    local color=$1
    local text=$2
    local fd=${3-}
    local begin=""
    local end=""

    if [[ -z "$fd" || -t "$fd" ]]; then
        end=$'\e[0m'

        case "$color" in
            red)    begin=$'\e[1;31m' ;;
            green)  begin=$'\e[1;32m' ;;
            yellow) begin=$'\e[1;33m' ;;
            blue)   begin=$'\e[1;34m' ;;
            purple) begin=$'\e[1;35m' ;;
            cyan)   begin=$'\e[1;36m' ;;
            white)  begin=$'\e[1;37m' ;;
        esac
    fi

    printf "%s" "${begin}${text}${end}"
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    colorize "$@"
fi


# vim:ft=bash
