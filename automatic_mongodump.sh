#!/bin/sh

show_help() {
cat << EOF
Usage: ./${0##*/} [-d BACKUP_LOCATION]...
Saves automatic weekly backup of all available databases to given directory.
    
    -h                  display this help and exit
    -d BACKUP_LOCATION  location for backups

EOF
}

BACKUP_DIR=`date +%d.%m.%y`

#initial values
BACKUP_LOCATION="db_backups"

OPTIND=1

while getopts hd: opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        d)
            BACKUP_LOCATION=$OPTARG
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"

printf 'Selected directory for weekly backup: %s\n' "$BACKUP_LOCATION"

DESTINATION="$BACKUP_LOCATION/$BACKUP_DIR"
mkdir -p DESTINATION
mongodump -h localhost:27017 -o $DESTINATION
