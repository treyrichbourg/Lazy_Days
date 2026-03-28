#!/bin/bash

BACKUP_MOUNT="/mnt/bank"
LOG_FILE="/var/log/rsync-home.log"

echo "$(date '+%F %T') - Backup job started." >>"$LOG_FILE"

if ! mountpoint -q "$BACKUP_MOUNT"; then
    echo "$(date '+%F %T') - Backup drive not mounted, aborting rsync." >>"$LOG_FILE"
    exit 1
fi

# --delete <- add delete flag back after a few successful runs for sanity 3-29-26 (next run)
if /usr/bin/rsync -aAXH \
    --exclude='.steam' \
    --exclude='Games' \
    --exclude='.cache' \
    --exclude='.local/share/Trash' \
    --exclude='.launchpadlib' \
    --exclude='Downloads' \
    /home/comet/ "$BACKUP_MOUNT/comet/" \
    2>>"$LOG_FILE"; then
    echo "$(date '+%F %T') - Backup completed successfully." >>"$LOG_FILE"
else
    rc=$?

    # Not logging failure for codes:
    # 23: file permission/read errors
    # 24: vanished files
    if [[ $rc -eq 0 || $rc -eq 23 || $rc -eq 24 ]]; then
        echo "$(date '+%F %T') - Backup completed successfully." >>"$LOG_FILE"
    else
        echo "$(date '+%F %T') - ERROR: Backup failed." >>"$LOG_FILE"
    fi
fi
