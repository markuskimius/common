##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

declare -F monitor-mem >/dev/null && return


function monitor-mem() {
    # Output from free
    if command -v free >/dev/null; then
        local name_by_index=()
        local line

        while IFS= read -r line; do
            local fields=( $line )

            if (( ${#name_by_index[@]} == 0 )); then
                name_by_index=( "type" "${fields[@]}" )
            else
                local i=0

                for (( i=1; i < ${#fields[@]}; i++ )); do
                    local name=${fields[0]}${name_by_index[$i]}
                    local value=${fields[$i]}

                    printf "%s,%s\n" "$name" "$value"
                done
            fi
        done < <(free)
    fi

    # Output from vm_stat
    if command -v vm_stat >/dev/null; then
        local name value

        shopt -s extglob

        while IFS=: read -d $'\n' -r name value; do
            name=${name//\"/}
            value=${value##+( )}

            printf "%s,%s\n" "${name%:}" "${value%.}"
        done < <(vm_stat)
    fi
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    monitor-mem "$@"
fi


# vim:ft=bash
