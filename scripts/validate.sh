#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

plutil -lint zh-Hans.lproj/Localizable.strings
plutil -lint zh-Hans.lproj/Localizable.stringsdict
plutil -lint zh-Hans.lproj/InfoPlist.strings
bash -n install.sh
bash -n uninstall.sh

echo "All localization files and scripts are valid."
