#!/usr/bin/env bash

set -euo pipefail
# set -x # print cmd

export SCRIPT_DIR="$(cd -- "$(dirname -- "$( readlink -f -- "$0"; )")" &> /dev/null && pwd )"
export OUT_DIR="$(cd -- "${SCRIPT_DIR}/../out" &> /dev/null && pwd )"

certstrap --depot-path="$OUT_DIR" init \
    --organization "Basa62" \
    --organizational-unit "Test Org" \
    --country "RS" \
    --province "BG" \
    --locality "Company" \
    --common-name "Testing Root"
