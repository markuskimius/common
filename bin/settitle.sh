##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

function settitle() {
    TITLE="${*-}"

    if (( ! $# )); then
        TITLE="${USER-$(whoami)}@${HOSTNAME-$(hostname)}"
    fi

    printf "\e]0;%s\a" "$TITLE"
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    settitle "$@"
fi


# vim:ft=bash
