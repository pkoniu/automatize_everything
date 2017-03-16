#!/bin/sh

#initial values
BACKUP_LOCATION="db_backups"
EXPIRATION=30

show_help() {
cat << EOF
Usage: ./${0##*/} [-d BACKUP_LOCATION] [-t EXPIRATION]...
Removes backups from given directory older then given expiration in days.
    
    -h                  display this help and exit
    -d BACKUP_LOCATION  location for backups, defaults to $BACKUP_LOCATION
    -t EXPIRATION       dirs older than that will be removed, defaults to $EXPIRATION

EOF
}

OPTIND=1

while getopts hdt: opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        d)
            BACKUP_LOCATION=$OPTARG
            ;;
        t)
            EXPIRATION=$OPTARG
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"

printf 'Selected directory for weekly backup: %s\n' "$BACKUP_LOCATION"
printf 'Directories older than %d will be removed\n' "$EXPIRATION"

find $BACKUP_LOCATION/* -type d -ctime +$EXPIRATION | xargs rm -rf