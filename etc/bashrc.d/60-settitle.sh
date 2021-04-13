#!/bin/bash

##############################################################################
# COFFEE: Unix utilities I use way too much
# https://github.com/markuskimius/coffee
#
# Copyright (c)2020 Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/coffee/blob/master/LICENSE
##############################################################################

function coffee::settitle() {
    TITLE="${*-}"

    if (( ! $# )); then
        TITLE="${USER}@${HOSTNAME}"
    fi

    printf "\e]0;%s\a" "$TITLE"
}


##############################################################################
# TEST CODE

if (( ${#BASH_SOURCE[@]} == 1 )); then
    include "bashlib.sh"
    include "getopt.sh"

    function main() {
        coffee::settitle 'Hi there'

        [[ "$TITLE" == 'Hi there' ]] || die
    }

    main "$@"
fi
