#!/bin/bash

##############################################################################
# COFFEE: Unix utilities I use way too much
# https://github.com/markuskimius/coffee
#
# Copyright (c)2020 Mark K. Kim
# Released under the Apache license 2.0
# https://github.com/markuskimius/coffee/blob/master/LICENSE
##############################################################################

function coffee::include() {
    declare file=${1-}
    declare frame=${2-2}
    declare fullpath
    declare truepath

    # Find the library
    case "$file" in
        /*)     # Full path
                fullpath=$file
                ;;

        .*/*)   # Relative to the calling script's directory
                fullpath=$(dirname "$(readlink -f "${BASH_SOURCE[$((frame-1))]}")")/$file
                ;;

        *)      # Search ${CAFE}/*/lib/
                declare dir

                # Look for $file in the lib path
                for dir in "${CAFE}"/*/lib; do
                    if [[ -e "$dir/$file" ]]; then
                        fullpath="$dir/$file"
                        break
                    fi
                done
                ;;
    esac

    if [[ -z "${fullpath-}" ]]; then
        coffee::log ERROR "File not found -- $file" "$frame"
        return 1
    fi

    if [[ ! -r "$fullpath" ]]; then
        coffee::log ERROR "File not readable -- $fullpath" "$frame"
        return 1
    fi

    truepath=$(readlink -f "$fullpath")

    if [[ ":${__COFFEE_INCLUDED-}:" != *":$truepath:"* ]]; then
        __COFFEE_INCLUDED=${__COFFEE_INCLUDED-}${__COFFEE_INCLUDED+:}${truepath}
        source "$truepath"
    fi
}


##############################################################################
# TEST CODE

if (( ${#BASH_SOURCE[@]} == 1 )); then
    coffee::include getopt.sh

    function main() {
        declare OPTOPT OPTARG OPTERR OPTARRAY

        while coffee::getopt "ho:" "help,output:" "$@"; do
            echo "${OPTOPT}=${OPTARG}"
        done

        echo "args=${OPTARRAY[@]}"
    }

    main "$@"
fi
