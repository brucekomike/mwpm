#!/usr/bin/env bash

# load config
source config.sh
source lib.sh

API_URL="api.php"
echo "Logging into $MW_URL as $MW_USER"
mw-login
echo "Login finished."
