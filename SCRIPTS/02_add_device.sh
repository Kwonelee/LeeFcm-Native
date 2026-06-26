#!/bin/bash -e

# ============================================================================================================
# 添加设备⬇⬇⬇
echo -e "\\ndefine Device/firefly_station-m2
  DEVICE_VENDOR := Firefly
  DEVICE_MODEL := Station M2 / RK3566 ROC PC
  SOC := rk3566
  DEVICE_DTS := rk3566-roc-pc
  SUPPORTED_DEVICES += firefly,rk3566-roc-pc firefly,station-m2
  UBOOT_DEVICE_NAME := station-m2-rk3566
  IMAGE/sysupgrade.img.gz := boot-common | boot-script | pine64-img | gzip | append-metadata
  DEVICE_PACKAGES := kmod-nvme kmod-scsi-core
endef
TARGET_DEVICES += firefly_station-m2" >> target/linux/rockchip/image/armv8.mk

echo -e "\\ndefine Device/rockchip_wocyber-a3
  DEVICE_VENDOR := Rockchip
  DEVICE_MODEL := Wocyber A3
  SOC := rk3568
  DEVICE_DTS := rk3568-wocyber-a3
  SUPPORTED_DEVICES += rockchip,wocyber-a3
  UBOOT_DEVICE_NAME := wocyber-a3-rk3568
  IMAGE/sysupgrade.img.gz := boot-common | boot-script | pine64-img | gzip | append-metadata
endef
TARGET_DEVICES += rockchip_wocyber-a3" >> target/linux/rockchip/image/armv8.mk

cp -f $GITHUB_WORKSPACE/FILES/uboot-rockchip/211-rockchip-rk3568-add-support-more-devices.patch target/linux/rockchip/patches-6.12/

# 替换package/boot/uboot-rockchip/Makefile
cp -f $GITHUB_WORKSPACE/FILES/uboot-rockchip/Makefile package/boot/uboot-rockchip/Makefile

# 复制uboot配置、dts到package/boot/uboot-rockchip
mkdir -p package/boot/uboot-rockchip/src/arch/arm/dts
mkdir -p package/boot/uboot-rockchip/src/configs
cp -f $GITHUB_WORKSPACE/FILES/dts/*.dts package/boot/uboot-rockchip/src/arch/arm/dts/
cp -f $GITHUB_WORKSPACE/FILES/uboot-rockchip/*.dtsi package/boot/uboot-rockchip/src/arch/arm/dts/
cp -f $GITHUB_WORKSPACE/FILES/uboot-rockchip/*_defconfig package/boot/uboot-rockchip/src/configs/

# 复制dts到files/arch/arm64/boot/dts/rockchip
mkdir -p target/linux/rockchip/files/arch/arm64/boot/dts/rockchip
cp -f $GITHUB_WORKSPACE/FILES/dts/*.dts target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/
# 添加设备⬆⬆⬆
# ============================================================================================================
