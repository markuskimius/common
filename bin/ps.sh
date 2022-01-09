##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

declare -F ps-sh >/dev/null && return


function ps-sh() {
    #
    # ps on cygwin is incompatible with our package, but the procps package
    # provides a compatible alternative.  Use procps if available, otherwise
    # use ps.
    #

    if command -v procps >/dev/null; then
        procps "$@"
    else
        ps "$@"
    fi
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    ps-sh "$@"
fi


# vim:ft=bash
