#!/bin/bash
printf "\n\n\n"
date +%d-%m-%y/%H:%M:%S
echo "--------------------------"
. ~/.keychain/`/bin/hostname`-sh
cd "$(dirname "$0")"
git commit timestamps.csv -m auto-commit
git push origin master