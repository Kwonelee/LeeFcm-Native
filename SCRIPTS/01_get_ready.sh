#!/bin/bash -e

# package/fcm拉取
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package/
  cd .. && rm -rf $repodir
}

git_sparse_clone fanchmwrt-25.12.4 https://github.com/fanchmwrt/fanchmwrt package/fcm

# fanchmwrt处理
sed -i 's/tty1::askfirst/tty1::respawn/g' target/linux/x86/base-files/etc/inittab
cp -f $GITHUB_WORKSPACE/FILES/fcmfiles/base-files/banner package/base-files/files/etc/banner
cp -f $GITHUB_WORKSPACE/FILES/fcmfiles/base-files/sysupgrade.conf package/base-files/files/etc/sysupgrade.conf
cp -f $GITHUB_WORKSPACE/FILES/fcmfiles/950-fwx-nf-conn-struct-user-hook.patch target/linux/generic/hack-6.12/
cp -f $GITHUB_WORKSPACE/FILES/fcmfiles/target.mk include/target.mk
cp -f $GITHUB_WORKSPACE/FILES/fcmfiles/base-files/rc.local package/base-files/files/etc/rc.local
cp -f $GITHUB_WORKSPACE/FILES/fcmfiles/base-files/login.sh package/base-files/files/usr/libexec/login.sh
cp -f $GITHUB_WORKSPACE/FILES/fcmfiles/base-files/Makefile package/base-files/Makefile
cp -a $GITHUB_WORKSPACE/FILES/fcmfiles/Makefile Makefile
cp -a $GITHUB_WORKSPACE/FILES/fcmfiles/feature.cfg package/fcm/fwxd/files/feature.cfg
sed -i "s/hostname='LEDE'/hostname='FanchmWrt'/g" package/base-files/files/bin/config_generate
#sed -i 's/default "LEDE"/default "FanchmWrt"/g' package/base-files/image-config.in
sed -i 's/LEDE/OpenWrt/g' package/base-files/image-config.in
sed -i 's/lede/openwrt/g' package/base-files/image-config.in
sed -i 's/LEDE/OpenWrt/g' package/lean/default-settings/files/zzz-default-settings
sed -i '/samba/d' package/lean/default-settings/files/zzz-default-settings

# luci-theme-fanchmwrt主题处理
# css图标定义、菜单icon替换
cp -rf $GITHUB_WORKSPACE/FILES/fanchmwrt/* package/fcm/luci-theme-fanchmwrt/htdocs/luci-static/fanchmwrt/
# 右上角图标、Home图标引用
cp -f $GITHUB_WORKSPACE/FILES/menu-fanchmwrt.js package/fcm/luci-theme-fanchmwrt/htdocs/luci-static/resources/menu-fanchmwrt.js

# 更新odhcpd
cp -a $GITHUB_WORKSPACE/FILES/odhcpd/Makefile package/network/services/odhcpd/Makefile
cp -a $GITHUB_WORKSPACE/FILES/odhcp6c/Makefile package/network/ipv6/odhcp6c/Makefile

# 使用6.18内核
#sed -i "s/6.12/6.18/g" target/linux/rockchip/Makefile
