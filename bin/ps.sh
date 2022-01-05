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

    command -v procps >/dev/null \
    && procps "$@"               \
    || ps "$@"
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    realpath-sh "$@"
fi


# vim:ft=bash
