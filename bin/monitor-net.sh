##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

declare -F monitor-net >/dev/null && return


function monitor-net() {
    local names=()
    local values=()
    local lineno=0
    local line
    local i

    # Sum the values from all network interfaces
    while IFS= read -r line; do
        local fields=( $line )

        if (( lineno == 0 )); then
            # Skip the first line
            :
        elif (( lineno == 1 )); then
            names=( "${fields[@]}" )
        else
            for (( i=0; i < ${#fields[@]}; i++ )); do
                values[i]=$(( ${values[i]-0} + fields[i] ))
            done
        fi

        (( lineno += 1 ))
    done < <(netstat -i)

    # Print the accumulated values
    for (( i=0; i < ${#names[@]}; i++ )); do
        printf "%s,%s\n" "${names[i]}" "${values[i]}"
    done
}


# vim:ft=bash
