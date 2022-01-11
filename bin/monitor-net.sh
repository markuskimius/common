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
    done < <(netstat -ndi 2>/dev/null)

    # Try netstat -e if netstat -ndi fails (netstat format on Windows)
    if (( ${#names[@]} == 0 )); then
        local colnames=()
        local fields=()

        while IFS= read -r line; do
            line=${line/$'\r'/}                          # Strip carriage return
            line=${line/ /}                              # Strip one space that may be in row name
            fields=( $line )

            # Skip some rows
            [[ "$line" == *"Statistics"* ]] && continue  # First line on Windows
            [[ "$line" == "" ]] && continue              # Empty line

            # Header row
            if (( ${#colnames[@]} == 0 )); then
                colnames=( "${fields[@]}" )
                continue
            fi

            # Data row
            for (( i=0; i < ${#colnames[@]}; i++ )); do
                names+=( "${fields[0]}-${colnames[i]}" )
                values+=( "${fields[i+1]}" )
            done
        done < <(netstat -e)
    fi

    # Print the accumulated values
    for (( i=0; i < ${#names[@]}; i++ )); do
        # Map macOS/Widnows headers to Linux headers
        case "${names[i]}" in
            Name)                   names[i]="Iface"  ;;
            Mtu)                    names[i]="MTU"    ;;
            Ipkts|Bytes-Received)   names[i]="RX-OK"  ;;
            Ierrs|Errors-Received)  names[i]="RX-ERR" ;;
            Drop|Discards-Received) names[i]="RX-DRP" ;;
            Opkts|Bytes-Sent)       names[i]="TX-OK"  ;;
            Oerrs|Errors-Sent)      names[i]="TX-ERR" ;;
            Coll|Discards-Sent)     names[i]="TX-DRP" ;;
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
