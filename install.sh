#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
APP="/Applications/Tailscale.app"
SRC="$ROOT/zh-Hans.lproj"
DEST="$APP/Contents/Resources/zh-Hans.lproj"

if [ ! -d "$APP" ]; then
  echo "未找到 $APP，请先安装 Tailscale 独立版。"
  exit 1
fi

BUNDLE_ID="$(/usr/bin/defaults read "$APP/Contents/Info.plist" CFBundleIdentifier 2>/dev/null || true)"
if [ "$BUNDLE_ID" != "io.tailscale.ipn.macsys" ]; then
  echo "仅支持 Tailscale 独立版（io.tailscale.ipn.macsys），当前为：${BUNDLE_ID:-未知}"
  echo "Mac App Store 版不支持此语言包。"
  exit 1
fi

for file in Localizable.strings Localizable.stringsdict InfoPlist.strings; do
  if [ ! -f "$SRC/$file" ]; then
    echo "缺少语言资源：$SRC/$file"
    exit 1
  fi
done

if [ "$(id -u)" -ne 0 ]; then
  echo "需要管理员权限，正在请求授权…"
  /usr/bin/osascript -e "do shell script \"/bin/bash '${ROOT}/install.sh'\" with administrator privileges"
  exit $?
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
cp -R "$SRC" "$TMP/zh-Hans.lproj"
/usr/bin/plutil -convert binary1 "$TMP/zh-Hans.lproj/Localizable.strings"
/usr/bin/plutil -convert binary1 "$TMP/zh-Hans.lproj/InfoPlist.strings"

rm -rf "$DEST"
cp -R "$TMP/zh-Hans.lproj" "$DEST"
chown -R root:wheel "$DEST"
chmod 755 "$DEST"
chmod 644 "$DEST"/*

echo "中文语言包已安装到 $DEST"
echo "请从菜单栏退出 Tailscale，然后重新打开 App 以生效。"
