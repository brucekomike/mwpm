#!/bin/bash 
source lib.sh
source config.sh

TARGET_USERNAME=${MW_USER%%@*}
if [[ "$TARGET_USERNAME" != "$(query-username "$MW_URL")" ]]; then
  echo "Logging in to $MW_URL as $TARGET_USERNAME..."
  mw-login "$MW_URL" "$MW_USER" "$MW_PASS"
  echo "Logged in as $TARGET_USERNAME"
else
  echo "Already logged in as $TARGET_USERNAME"
fi