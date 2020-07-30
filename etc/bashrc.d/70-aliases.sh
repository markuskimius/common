#!/bin/bash

##############################################################################
# COFFEE: Unix utilities I use way too much
# https://github.com/markuskimius/coffee
#
# Copyright (c)2020 Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/coffee/blob/master/LICENSE
##############################################################################

alias log=coffee::log
alias throw=coffee::throw
alias include=coffee::include
alias settitle=coffee::settitle

shopt -s expand_aliases


##############################################################################
# TEST CODE

if (( ${#BASH_SOURCE[@]} == 1 )); then
    function main() {
        myfunction1 "$@"
    }

    function myfunction1() {
        myfunction2 "$@"
    }

    function myfunction2() {
        myfunction3 "$@"
    }

    function myfunction3() {
        throw "Test exception:" 2
    }

    main "$@"
fi
