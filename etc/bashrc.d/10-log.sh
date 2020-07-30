#!/bin/bash

##############################################################################
# COFFEE: Unix utilities I use way too much
# https://github.com/markuskimius/coffee
#
# Copyright (c)2020 Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/coffee/blob/master/LICENSE
##############################################################################

export COFFEE_LOGLEVEL=${COFFEE_LOGLEVEL-"ERROR"}

function coffee::log() {
    declare level=$1
    declare message=${2-}
    declare frame=${3-1}

    # Output the message only if it's in $COFFEE_LOGLEVEL
    [[ " ${COFFEE_LOGLEVEL} " == *" ${level} "* ]] || return

    if [[ -n "${message-}" ]]; then
        coffee::log-brief "$message" "$frame"
    else
        coffee::log-verbose "$frame"
    fi
}

function coffee::log-brief() {
    declare message=$1
    declare frame=${2-0}
    declare lineno func file

    read -r lineno func file <<<$(caller "$frame" || :)

    echo "${COFFEE_LOGLEVEL} in ${file} line ${lineno}: ${message}" 1>&2
}

function coffee::log-verbose() {
    declare frame=${1-0}
    declare lineno func file

    read -r lineno func file <<<$(caller "$frame" || :)

    (
        declare timestamp=$(date "+%Y-%m-%d %H:%M:%S.%N %Z")
        declare colstart
        declare line

        # Leader
        echo "LOG_${COFFEE_LOGLEVEL} at ${timestamp::23} ${timestamp:30} in ${file} line ${lineno}:"

        # Read message from stdin
        while IFS='' read -r line; do
            if [[ -z "${colstart-}" ]]; then
                declare tmp=${line/%[^ ]*/}
        
                colstart=${#tmp}
            fi
        
            echo "${line:$colstart}"
        done

        # Break
        echo
    ) 1>&2
}


##############################################################################
# TEST CODE

if (( ${#BASH_SOURCE[@]} == 1 )); then
    function main() {
        coffee::log ERROR "Hello, world!"
        coffee::log ERROR <<<"Hello, world!"
    }

    main "$@"
fi
