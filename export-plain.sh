#!/usr/bin/env bash

source config.sh
source lib.sh

FILE="$1" # Replace with your actual file name

# Check if the file exists
if [[ ! -f "$FILE" ]]; then
    echo "Error: File '$FILE' not found."
    exit 1
fi

SITE_NAME=${SRC_URL%/}
SITE_NAME=${SITE_NAME/https:\/\/}
FILE_NAME=$(basename "$FILE")
export EXPORT_DIR="cache/$SITE_NAME/${FILE_NAME%.txt}"
mkdir -p "$EXPORT_DIR"
echo "Processing lines from '$FILE'"
batch-process "$FILE" 'mkdir -p $EXPORT_DIR/$(dirname $trimmed_line)'
batch-process "$FILE" 'export-plain $trimmed_line > $EXPORT_DIR/$trimmed_line.wikitext'

echo "Finished processing."
  