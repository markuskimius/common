#!/bin/bash

##############################################################################
# COFFEE: Unix utilities I use way too much
# https://github.com/markuskimius/coffee
#
# Copyright (c)2020 Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/coffee/blob/master/LICENSE
##############################################################################

function coffee::throw() {
    declare message=${1-"Exception:"}
    declare frame=${2-1}

    (
        echo "${message}"
        coffee::stacktrace "${frame}"
    ) 1>&2

    exit 255
}

function coffee::stacktrace() {
    declare frame=${1-0}
    declare lineno func file

    while true; do
        read -r lineno func file <<<$(caller "$frame" || :)
        [[ -n "${lineno-}" ]] || break

        printf "  %s:%s in %s() [%d]\n" "${file-}" "${lineno-}" "${func-}" "$frame"
        frame=$(( frame + 1 ))
    done
}


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
        coffee::throw "Test exception:" 2
    }

    main "$@"
fi
