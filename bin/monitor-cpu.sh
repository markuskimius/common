##############################################################################
# COMMON: Unix utilities
# https://github.com/markuskimius/common
#
# Copyright (c)2020-2021 Mark Kim
# Released under GNU General Public License version 2.
# https://github.com/markuskimius/common/blob/main/LICENSE
##############################################################################

declare -F monitor-cpu >/dev/null && return


function monitor-cpu() {
    if command -v mpstat >/dev/null; then
        mpstat -o JSON | jq -j '.sysstat.hosts[0].statistics[0]."cpu-load"[0] | to_entries[] | "%", .key, ",", .value, "\n"'
    elif command -v iostat >/dev/null; then
        local names=()
        local values=()
        local line

        while IFS= read -r line; do
            local fields=( ${line#* } )

            # Skip some rows
            [[ "$line" == *average* ]] && continue  # First line on macOS
            [[ "$line" == *CPU* ]] && continue      # First line on Linux
            [[ "$line" == "" ]] && continue         # Empty row

            # Header row
            if (( ${#names[@]} == 0 )); then
                names=( "${fields[@]}" )
                continue
            fi

            # Data row
            for (( i=0; i < ${#fields[@]}; i++ )); do
                # Skip columns without summable values
                # case "${names[i]}" in
                #     Name|Iface) continue ;;
                #     Mtu|MTU)    continue ;;
                #     Network)    continue ;;
                #     Address)    continue ;;
                # esac

                values[i]=$(( ${values[i]-0} + ${fields[i]%.*} ))
            done
        done < <(iostat -c 2>/dev/null || iostat)

        # Print the accumulated values
        for (( i=0; i < ${#names[@]}; i++ )); do
            # Map iostat headers to mpstat headers
            case "${names[i]}" in
                us|%user)   names[i]="%usr"   ;;
                sy|%system) names[i]="%sys"   ;;
                id)         names[i]="%idle"  ;;
            esac

            printf "%s,%s\n" "${names[i]}" "${values[i]}"
        done
    fi
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    monitor-cpu "$@"
fi


# vim:ft=bash
