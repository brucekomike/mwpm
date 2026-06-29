#!/usr/bin/env bash

source config.sh
source lib.sh

FILE="$(search-pkg $1)" # Replace with your actual file name
FILE_NAME=$(basename "$FILE")
SITE_NAME=${SRC_URL%/}
SITE_NAME=${SITE_NAME/https:\/\/}

# Check if the file exists
if [[ ! -f "$FILE" ]]; then
    echo "Error: File '$FILE' not found."
    exit 1
fi

export EXPORT_FILE="cache-xml/$SITE_NAME/${FILE_NAME%.txt}.xml"
echo "Processing '$FILE'"
xml-import $EXPORT_FILE
echo "Finished processing."
