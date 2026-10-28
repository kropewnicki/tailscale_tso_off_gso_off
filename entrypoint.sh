#!/bin/sh

# Monitor network offloading settings
(
    while true; do

        for iface in eth0 tailscale0; do

            if ip link show "$iface" >/dev/null 2>&1; then

                if ethtool -k "$iface" 2>/dev/null |
                   grep -Eq '^(tcp-segmentation-offload|generic-segmentation-offload): on'; then

                    echo "Disabling TSO/GSO on $iface"

                    ethtool -K "$iface" tso off gso off ||
                        echo "WARNING: Failed to disable TSO/GSO on $iface"

                fi

            fi

        done

        sleep 10

    done
) &

# Start official Tailscale container
exec /usr/local/bin/containerboot "$@"