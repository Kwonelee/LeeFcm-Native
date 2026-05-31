#!/bin/bash -e

# ============================================================================================================
# 自定义DIY⬇⬇⬇
# TTYD
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

# samba4 default config
rm -rf feeds/packages/net/samba4/files/smb.auto
sed -i '/smb.auto/d' feeds/packages/net/samba4/Makefile
sed -i 's/invalid users = root/#invalid users = root/g' feeds/packages/net/samba4/files/smb.conf.template
sed -i 's/nas/services/g' feeds/luci/applications/luci-app-samba4/root/usr/share/luci/menu.d/luci-app-samba4.json

# default LAN IP
sed -i "s/192.168.1.1/192.168.5.88/g" package/base-files/files/bin/config_generate

# clash_meta
mkdir -p files/etc/openclash/core
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
chmod +x files/etc/openclash/core/clash*

# clash_config
mkdir -p files/etc/config
wget -qO- https://raw.githubusercontent.com/Kwonelee/Kwonelee/refs/heads/main/rule/openclash > files/etc/config/openclash

# 集成设备无线
#mkdir -p package/base-files/files/lib/firmware/brcm
#cp -a $GITHUB_WORKSPACE/FILES/firmware/brcm/* package/base-files/files/lib/firmware/brcm/

# golang 1.26
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang

# node - prebuilt
rm -rf feeds/packages/lang/node
git clone https://github.com/sbwml/feeds_packages_lang_node -b packages-24.10 feeds/packages/lang/node

# zerotier
rm -rf feeds/packages/net/zerotier
git clone https://github.com/sbwml/feeds_packages_net_zerotier feeds/packages/net/zerotier

# 替换app_icons
#rm -rf feeds/fanchmwrt/luci-app-fwx-appfilter/htdocs/luci-static/resources/app_icons
#cp -a $GITHUB_WORKSPACE/FILES/fcmfiles/app_icons feeds/fanchmwrt/luci-app-fwx-appfilter/htdocs/luci-static/resources/

# 移除待替换插件
rm -rf feeds/packages/net/{openlist,lucky}
rm -rf feeds/packages/utils/filebrowser
rm -rf feeds/luci/applications/luci-app-{passwall,openclash,zerotier,openlist,filebrowser,lucky,filebrowser-go}

# Git稀疏克隆，只克隆指定目录到package/new
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package/new
  cd .. && rm -rf $repodir
}

# 常见插件
git_sparse_clone master https://github.com/vernesong/OpenClash luci-app-openclash
git_sparse_clone main https://github.com/gdy666/luci-app-lucky luci-app-lucky lucky
cp -f $GITHUB_WORKSPACE/FILES/lucky_status.htm package/new/luci-app-lucky/luasrc/view/lucky/lucky_status.htm
sed -i "s/option enabled '1'/option enabled '0'/" package/new/lucky/files/luckyuci
git_sparse_clone main https://github.com/sbwml/luci-app-openlist2 luci-app-openlist2 openlist2
git_sparse_clone main https://github.com/sbwml/openwrt_pkgs luci-app-zerotier
git_sparse_clone main https://github.com/Kwonelee/openwrt-packages filebrowser luci-app-filebrowser-go
FB_VERSION="$(curl -s https://github.com/filebrowser/filebrowser/tags | grep -Eo 'v[0-9]+\.[0-9]+\.[0-9]+' | head -n 1 | sed 's/^v//')"
sed -i "s/2.54.0/$FB_VERSION/g" package/new/filebrowser/Makefile
# 自定义DIY⬆⬆⬆
# ============================================================================================================
