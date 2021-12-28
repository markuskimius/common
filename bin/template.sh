##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

declare -F template >/dev/null && return


##############################################################################
# FUNCTIONS

function template() {
    eval "cat <<__COMMON_TEMPLATE__$$
$(cat "$@")
__COMMON_TEMPLATE__$$"
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    template "$@"
fi


# vim:ft=bash
