#!/usr/bin/env bash

source config.sh

if [[ -z "$PKGS_URL" ]]; then
  echo "Error: PKGS_URL not set in config.sh" >&2
  exit 1
fi

for url in $PKGS_URL; do
  dir_name="${url##*/}"
  dir_name="${dir_name%.git}"

  if [[ -d "pkgs/$dir_name/.git" ]]; then
    echo "Pulling $dir_name"
    git -C "pkgs/$dir_name" pull
  else
    echo "Error: pkgs/$dir_name not cloned, run clone-pkgs.sh first" >&2
    exit 1
  fi
done

echo "Done."