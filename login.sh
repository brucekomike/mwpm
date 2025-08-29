#!/usr/bin/env bash

# load config
source config.sh
source lib.sh

# login to $MW_URL
mw-login "$MW_URL" "$MW_USER" "$MW_PASS"

if [[ $private_src == "true" ]]; then
  mw-login "$SRC_URL" "$SRC_USER" "$SRC_PASS"
fi

echo "Login finished."
