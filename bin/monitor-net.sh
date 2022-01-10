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
    local line
    local i

    # Sum the values from all network interfaces
    while IFS= read -r line; do
        local fields=( $line )

        # Skip some rows
        [[ "$line" == *Kernel* ]] && continue  # First line on Linux
        [[ "$line" == *Link* ]] && continue    # Row on macOS without a value in the address column

        # Header row
        if (( ${#names[@]} == 0 )); then
            names=( "${fields[@]}" )
            continue
        fi

        # Data row
        for (( i=0; i < ${#fields[@]}; i++ )); do
            # Skip columns without summable values
            case "${names[i]}" in
                Name|Iface) continue ;;
                Mtu|MTU)    continue ;;
                Network)    continue ;;
                Address)    continue ;;
            esac

            # "-" on macOS is same as 0
            [[ "${fields[i]}" == "-" ]] && fields[i]=0

            values[i]=$(( ${values[i]-0} + fields[i] ))
        done
    done < <(netstat -ndi)

    # Print the accumulated values
    for (( i=0; i < ${#names[@]}; i++ )); do
        # Map macOS headers to Linux headers
        case "${names[i]}" in
            Name)   names[i]="Iface"  ;;
            Mtu)    names[i]="MTU"    ;;
            Ipkts)  names[i]="RX-OK"  ;;
            Ierrs)  names[i]="RX-ERR" ;;
            Opkts)  names[i]="TX-OK"  ;;
            Oerrs)  names[i]="TX-ERR" ;;
            Coll)   names[i]="TX-DRP" ;;
            Drop)   names[i]="RX-DRP" ;;
        esac

        printf "%s,%s\n" "${names[i]}" "${values[i]}"
    done
}


##############################################################################
# ENTRY POINT

if (( ${#BASH_SOURCE[@]} == 1 )); then
    monitor-net "$@"
fi


# vim:ft=bash
