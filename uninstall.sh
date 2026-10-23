#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
APP="/Applications/Tailscale.app"
DEST="$APP/Contents/Resources/zh-Hans.lproj"

if [ "$(id -u)" -ne 0 ]; then
  echo "需要管理员权限，正在请求授权…"
  /usr/bin/osascript -e "do shell script \"/bin/bash '${ROOT}/uninstall.sh'\" with administrator privileges"
  exit $?
fi

if [ -d "$DEST" ]; then
  rm -rf "$DEST"
  echo "中文语言包已移除。请退出并重新打开 Tailscale 以恢复英文界面。"
else
  echo "未发现中文语言包，无需移除。"
fi
