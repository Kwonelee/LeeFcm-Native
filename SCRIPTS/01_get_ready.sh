#!/bin/bash -e

# fanchmwrt处理
sed -i 's/tty1::askfirst/tty1::respawn/g' target/linux/x86/base-files/etc/inittab
cp -f $GITHUB_WORKSPACE/FILES/fcmfiles/base-files/banner package/base-files/files/etc/banner
cp -f $GITHUB_WORKSPACE/FILES/fcmfiles/base-files/sysupgrade.conf package/base-files/files/etc/sysupgrade.conf
cp -f $GITHUB_WORKSPACE/FILES/fcmfiles/950-fwx-nf-conn-struct-user-hook.patch target/linux/generic/hack-6.12/
cp -f $GITHUB_WORKSPACE/FILES/fcmfiles/target.mk include/target.mk
cp -f $GITHUB_WORKSPACE/FILES/fcmfiles/base-files/rc.local package/base-files/files/etc/rc.local
cp -f $GITHUB_WORKSPACE/FILES/fcmfiles/base-files/login.sh package/base-files/files/usr/libexec/login.sh
cp -f $GITHUB_WORKSPACE/FILES/fcmfiles/base-files/Makefile package/base-files/Makefile
cp -a $GITHUB_WORKSPACE/FILES/fcmfiles/fcm package/
cp -a $GITHUB_WORKSPACE/FILES/fcmfiles/Makefile Makefile
sed -i "s/hostname='LEDE'/hostname='FanchmWrt'/g" package/base-files/files/bin/config_generate
#sed -i 's/default "LEDE"/default "FanchmWrt"/g' package/base-files/image-config.in
sed -i 's/LEDE/OpenWrt/g' package/base-files/image-config.in
sed -i 's/lede/openwrt/g' package/base-files/image-config.in
sed -i 's/LEDE/OpenWrt/g' package/lean/default-settings/files/zzz-default-settings
sed -i '/samba/d' package/lean/default-settings/files/zzz-default-settings

# fanchmwrt样式处理
cp -f $GITHUB_WORKSPACE/FILES/menu-fanchmwrt.js package/fcm/luci-theme-fanchmwrt/htdocs/luci-static/resources/menu-fanchmwrt.js
cp -rf $GITHUB_WORKSPACE/FILES/fanchmwrt/* package/fcm/luci-theme-fanchmwrt/htdocs/luci-static/fanchmwrt/

# 使用6.18内核
#sed -i "s/6.12/6.18/g" target/linux/rockchip/Makefile
