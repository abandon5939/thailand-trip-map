#!/bin/bash
set -e
cd /tmp

echo "📦 下载 gh CLI..."
rm -f gh.tar.gz gh.zip

# macOS 是 zip 格式，不是 tar.gz
curl -L -o gh.zip https://github.com/cli/cli/releases/download/v2.96.0/gh_2.96.0_macOS_arm64.zip

SIZE=$(wc -c < gh.zip 2>/dev/null || echo 0)
echo "下载完成: $SIZE bytes"

if [ "$SIZE" -lt 10000 ]; then
  echo "❌ 下载失败，可能是 GitHub 被墙"
  echo "试试 Vercel 地址: https://thailand-trip-kappa.vercel.app"
  exit 1
fi

unzip -o gh.zip
cp gh_*/bin/gh /tmp/gh
chmod +x /tmp/gh
echo "✅ gh 就绪"

echo ""
echo "🔑 登录 GitHub（会弹浏览器）..."
/tmp/gh auth login --hostname github.com --web --git-protocol https

echo ""
echo "📤 创建仓库并推送..."
cd /Users/panda/thailand-trip
git config user.name "helisan-san" 2>/dev/null || true
git config user.email "helisan-san@users.noreply.github.com" 2>/dev/null || true

/tmp/gh repo create thailand-trip-map --public --source=. --push --description "泰国三城之旅"

echo ""
echo "🌐 开启 GitHub Pages..."
/tmp/gh api repos/helisan-san/thailand-trip-map/pages -X POST -f "source[branch]=main" -f "source[path]=/" 2>&1 || echo "(可能需手动去 Settings > Pages 开启)"

echo ""
echo "=== ✅ 完成 ==="
echo "https://helisan-san.github.io/thailand-trip-map/"
