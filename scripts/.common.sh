#!/usr/bin/env bash

set -euo pipefail

export OUT_DIR="$(cd -- "$(dirname -- "$( readlink -f -- "$0"; )")/../out" &> /dev/null && pwd )"