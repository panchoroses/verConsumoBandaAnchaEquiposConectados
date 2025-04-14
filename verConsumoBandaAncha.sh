#!/bin/bash

echo -e "IP Monitoreada\t\tConsumo de Datos"
echo "--------------------------------------------"

tshark -i eth0 -a duration:90 -q -z conv,ip | awk '
/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/ {
    ip[$1]+=$3;
    ip[$2]+=$3;
}
END {
    for (i in ip) {
        size = ip[i];
        unit = "Bytes";
        if (size > 1073741824) {
            size /= 1073741824;
            unit = "GB";
        } else if (size > 1048576) {
            size /= 1048576;
            unit = "MB";
        } else if (size > 1024) {
            size /= 1024;
            unit = "KB";
        }
        printf "%-20s %-10.2f %s\n", i, size, unit;
    }
}' | sort -k2 -nr
