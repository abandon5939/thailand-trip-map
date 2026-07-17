#!/bin/bash
set -e

echo "=== 部署泰国行程地图到 GitHub Pages ==="

# 1. 下载 gh CLI
cd /tmp
if [ ! -f gh ]; then
  echo "📦 下载 gh CLI..."
  ARCH=$(uname -m)
  if [ "$ARCH" = "arm64" ]; then
    curl -L "https://github.com/cli/cli/releases/download/v2.96.0/gh_2.96.0_macOS_arm64.tar.gz" -o gh.tar.gz
  else
    curl -L "https://github.com/cli/cli/releases/download/v2.96.0/gh_2.96.0_macOS_amd64.tar.gz" -o gh.tar.gz
  fi
  tar -xzf gh.tar.gz
  cp gh_*/bin/gh /tmp/gh
  echo "✅ gh 下载完成"
fi

GH=/tmp/gh

# 2. 登录 GitHub
echo ""
echo "🔑 登录 GitHub..."
$GH auth login --hostname github.com --web --git-protocol https

# 3. 创建仓库并推送
echo ""
echo "📤 创建仓库并推送..."
cd /Users/panda/thailand-trip

git config user.name "helisan-san" 2>/dev/null || true
git config user.email "helisan-san@users.noreply.github.com" 2>/dev/null || true

$GH repo create thailand-trip-map --public --source=. --push \
  --description "泰国三城之旅交互地图：曼谷→清迈→苏梅岛 · 9/22-10/1"

# 4. 启用 GitHub Pages
echo ""
echo "🌐 启用 GitHub Pages..."
$GH api repos/helisan-san/thailand-trip-map/pages \
  -X POST \
  -f "source[branch]=main" \
  -f "source[path]=/" 2>/dev/null || echo "(如果报错，请手动去仓库 Settings > Pages 开启)"

echo ""
echo "=== 完成！ ==="
echo "你的地图地址："
echo "  https://helisan-san.github.io/thailand-trip-map/"
echo ""
echo "如果打不开，等 1-2 分钟让 GitHub 构建完成。"
echo "也可以去 https://github.com/helisan-san/thailand-trip-map/settings/pages 手动开启 Pages。"
