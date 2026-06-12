#!/usr/bin/env bash
# First-time installer for the Med-Spa Newsletter Suite (writer + humanizer).
# Delegates to the canonical sync script so install and update use identical logic.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$DIR/medspa-newsletter/sync.sh"
