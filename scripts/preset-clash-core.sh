#!/bin/sh
# Prepare OpenClash core + dashboards into image/files (ImageBuilder FILES=)
# Based on your existing preset-clash-core.sh, but kept standalone here.

set -eu

ARCH="${1:-amd64}"
OUT="${2:-image/files}"

mkdir -p "$OUT/etc/openclash/core" "$OUT/etc/openclash" \
  "$OUT/usr/share/openclash/ui/yacd" \
  "$OUT/usr/share/openclash/ui/metacubexd" \
  "$OUT/usr/share/openclash/ui/zashboard"

MIHOMO_PAGE="https://github.com/vernesong/mihomo/releases/expanded_assets/Prerelease-Alpha"
MIHOMO_URL=$(wget -qO- "$MIHOMO_PAGE" | grep -oE "/vernesong/mihomo/releases/download/[^\"']*mihomo-linux-${ARCH}-alpha-smart[^\"']*.gz" | head -n1 || true)
[ -n "$MIHOMO_URL" ] || { echo "failed to find mihomo asset for arch=$ARCH" >&2; exit 1; }
MIHOMO_URL="https://github.com${MIHOMO_URL}"

GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
GEO_MMDB_URL="https://raw.githubusercontent.com/Loyalsoldier/geoip/release/Country-only-cn-private.mmdb"

YACD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/Yacd-meta.tar.gz"
METACUBEXD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/metacubexd.tar.gz"
ZASHBOARD_META_URL="https://github.com/DustinWin/proxy-tools/releases/download/Dashboard/zashboard.tar.gz"

echo "[openclash] downloading mihomo: $MIHOMO_URL"
wget -qO- "$MIHOMO_URL" | gunzip -c > "$OUT/etc/openclash/core/clash_meta"
chmod +x "$OUT/etc/openclash/core/clash_meta"

echo "[openclash] downloading dashboards"
wget -qO- "$YACD_META_URL" | tar -xz -C "$OUT/usr/share/openclash/ui/yacd"
wget -qO- "$METACUBEXD_META_URL" | tar -xz -C "$OUT/usr/share/openclash/ui/metacubexd"
wget -qO- "$ZASHBOARD_META_URL" | tar -xz -C "$OUT/usr/share/openclash/ui/zashboard"

echo "[openclash] downloading geo databases"
wget -qO "$OUT/etc/openclash/GeoIP.dat" "$GEOIP_URL"
wget -qO "$OUT/etc/openclash/GeoSite.dat" "$GEOSITE_URL"
wget -qO "$OUT/etc/openclash/Country-only-cn-private.mmdb" "$GEO_MMDB_URL"

echo "[openclash] core version:"
"$OUT/etc/openclash/core/clash_meta" -v || true
