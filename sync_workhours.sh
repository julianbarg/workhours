#!/bin/bash
. ~/.keychain/`/bin/hostname`-sh
cd "$(dirname "$0")"
git commit timestamps.csv -m auto-commit
git push origin master