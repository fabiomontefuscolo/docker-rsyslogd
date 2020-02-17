#!/bin/bash
set -x

if [ -n "${SYSLOG_SOCK}" ];
then
    ln -sf "${SYSLOG_SOCK}" /dev/log
fi

exec "$@"
