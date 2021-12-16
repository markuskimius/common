#!/bin/bash

##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

function usage() {
    cat <<EOF
Usage: ${SCRIPTNAME} [OPTIONS] COMMAND [ARGUMENTS]

OPTIONS:
  -o FILENAME           Save the output to FILENAME.  [Default=${OUTPUT}]

EOF
}


##############################################################################
# PROGRAM BEGINS HERE

source "logger.sh" || exit 1
source "timestamp.sh" || exit 1


SCRIPTNAME=$(basename -- "$BASH_SOURCE")
OUTPUT=profile.out


function main() {
    local OPTIND OPTERR OPTARG opt
    local isok=1

    # Check arguments
    while getopts "o:" opt; do
        case "$opt" in
            o)  OUTPUT=$OPTARG ;;
            *)  logger FAIL "${1}: Invalid command"
                isok=0         ;;
        esac
    done

    # Sanity check
    if (( ! isok )); then
        usage 1>&2
        exit 1
    fi

    profile-sh "$@"
}


function profile-sh() {
    local command=$(command -v "$1") && shift
    local line

    export PS4='+|__PROFILE__|${BASH_SOURCE}|${FUNCNAME--}|${LINENO}|'

    ( ( BASH_XTRACEFD=127 bash -x "$command" "$@" 127>&1 1>&126 | profile-ts ) 126>&1 1>&127 ) 127> "$OUTPUT"
}


##############################################################################
# ENTRY POINT

main "$@"
