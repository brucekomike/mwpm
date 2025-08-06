#!/usr/bin/env bash

source config.sh
source lib.sh

# check file
FILE="$1"
FILENAME=$(basename "$FILE")
if [[ ! -f "$FILE" ]]; then
    echo "Error: File '$FILE' not found."
    exit 1
fi

page_list=""
#page_list+="$trimmed_line|"

batch-process "$FILE" 'page_list+="$trimmed_line|"'
page_list=${page_list%|}
echo "Processing pages: $page_list"
RESULT=$(export-xml "$page_list")
RESULT=$(jq -r '.query.export."*"' <<< "$RESULT")
echo $RESULT > "export/${FILENAME%.*}.xml"
echo "Finished processing."
