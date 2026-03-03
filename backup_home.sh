#!/bin/bash

BACKUP_MOUNT="/mnt/bank"

if ! mountpoint -q "$BACKUP_MOUNT"; then
    echo "$(date '+%F %T') - Backup drive not mounted, aborting rsync." >>/var/log/rsync-home.log
    exit 1
fi

/usr/bin/rsync -aAXHv \
    --exclude='.steam' \
    --exclude='Games' \
    --exclude='.cache' \
    --exclude='.local/share/Trash' \
    --exclude='Downloads' \
    /home/comet/ "$BACKUP_MOUNT/comet/" \
    --delete >>/var/log/rsync-home.log 2>&1
