#!/usr/bin/env bash

# load config
source config.sh
source lib.sh

# login to $MW_URL
echo "logging into $MW_URL"
mw-login "$MW_URL" "$MW_USER" "$MW_PASS"
echo
if [[ $private_src == "true" ]]; then
  echo "logging into $SRC_URL"
  mw-login "$SRC_URL" "$SRC_USER" "$SRC_PASS"
  echo
fi

echo "process finished."
