#!/usr/bin/env bash

set -euo pipefail
# set -x # print cmd

source ./.common.sh

certstrap -depot-dir="$OUR_DIR"

certstrap init \
    --organization "Basa62" \
    --organizational-unit "Test Org" \
    --country "RS" \
    --province "BG" \
    --locality "Company" \
    --common-name "Testing Root"
