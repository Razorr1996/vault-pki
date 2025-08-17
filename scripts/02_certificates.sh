#!/usr/bin/env bash

set -euo pipefail
# set -x # print cmd

SCRIPT_DIR="$(cd -- "$(dirname -- "$( readlink -f -- "$0"; )")" &> /dev/null && pwd )"
OUT_DIR="$(cd -- "${SCRIPT_DIR}/../out" &> /dev/null && pwd )"

certstrap --depot-path="$OUT_DIR" init \
    --expires "10 year" \
    --organization "Basa62" \
    --organizational-unit "Test Org" \
    --country "RS" \
    --province "BG" \
    --locality "Company1" \
    --common-name "Testing Root"

certstrap sign \
    --expires "3 year" \
    --csr "$OUT_DIR/Intermediate_CA1_v1.csr" \
    --cert "$OUT_DIR/Intermediate_CA1_v1.crt" \
    --intermediate \
    --path-length "1" \
    --CA "Testing Root" \
    "Intermediate CA1 v1"
