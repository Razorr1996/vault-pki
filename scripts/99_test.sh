#!/usr/bin/env bash

set -euo pipefail
# set -x # print cmd

OUT_DIR="$(cd -- "$(dirname -- "$( readlink -f -- "$0"; )")/../out" &> /dev/null && pwd )"

echo "$OUT_DIR"
