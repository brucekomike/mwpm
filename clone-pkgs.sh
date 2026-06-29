#!/usr/bin/env bash

source config.sh

if [[ -z "$PKGS_URL" ]]; then
  echo "Error: PKGS_URL not set in config.sh" >&2
  exit 1
fi

#mkdir -p pkgs

for url in $PKGS_URL; do
  dir_name="${url##*/}"
  dir_name="${dir_name%.git}"

  if [[ -d "pkgs/$dir_name/.git" ]]; then
    echo "Skipping $dir_name (already cloned)"
  elif [[ -d "pkgs/$dir_name" ]]; then
    echo "Error: pkgs/$dir_name already exists" >&2
    exit 1
  else
    echo "Cloning $dir_name from $url"
    git -C pkgs clone "$url" "$dir_name"
  fi
done

echo "Done."
