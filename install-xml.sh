#!/usr/bin/env bash

source config.sh
source lib.sh

FILE="$1" # Replace with your actual file name

# Check if the file exists
if [[ ! -f "$FILE" ]]; then
    echo "Error: File '$FILE' not found."
    exit 1
fi

echo "Processing lines from '$FILE'"
xml-import $FILE
echo "Finished processing."
