#!/bin/bash
set -x

if [ -n "${SYSLOG_SOCK}" ];
then
    ln -sf "${SYSLOG_SOCK}" /dev/log
fi

if [ -d "/entrypoint.d" ];
then
    for extra in /entrypoint.d/*; do
        case "$extra" in
            *.sh)     . "$extra" ;;
        esac
        echo
    done
    unset extra
fi

exec "$@"
