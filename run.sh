#/usr/bin/env bash
set -e
cp -r src "${mod_dir}"/"${mod_name}"
steam-run "${factorio}"
