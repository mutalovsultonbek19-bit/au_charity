#!/usr/bin/env bash
set -euo pipefail
# Run from the mobile folder after installing Flutter SDK.
flutter create --platforms=android --org uz.angrenuniversity .
echo "Android platform files are ready."
