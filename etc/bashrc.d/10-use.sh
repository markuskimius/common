#!/bin/bash

##############################################################################
# COFFEE: Unix utilities I use way too much
# https://github.com/markuskimius/coffee
#
# Copyright (c)2020 Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/coffee/blob/master/LICENSE
##############################################################################

function coffee::use() {
    case $1 in
        strict) coffee::use-strict   ;;
        ext*)   coffee::use-extended ;;
        *)      coffee::throw "Invalid argument to 'use' -- $1" ;;
    esac
}

function coffee::use-strict() {
    trap coffee::throw ERR  # Trap any nonzero return values
    shopt -so errtrace      # ERR traps are inherited by function calls

    shopt -so nounset       # Do not allow reading of uninitialized variable
    shopt -so errexit       # Exit script if any nonzero exit status is not caught
    shopt -so pipefail      # Exit status of any command in a pipe chain is the exit status of the chain
    shopt -so noclobber     # Do not allow exiting file to be redirected to
}

function coffee::use-extended() {
    shopt -s extglob      # Enable extended glob
    shopt -s globstar     # ** expands to subdirectories
}


##############################################################################
# TEST CODE

if (( ${#BASH_SOURCE[@]} == 1 )); then
    function main() {
        coffee::use strict
        coffee::use extended

        myfunction1 "$@"
    }

    function myfunction1() {
        myfunction2 "$@"
    }

    function myfunction2() {
        myfunction3 "$@"
    }

    function myfunction3() {
        ( exit 1 )
    }

    main "$@"
fi
