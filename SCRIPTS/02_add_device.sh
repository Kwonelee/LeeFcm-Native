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

# 替换package/boot/uboot-rockchip/Makefile
cp -f $GITHUB_WORKSPACE/FILES/uboot-rockchip/Makefile package/boot/uboot-rockchip/Makefile

# 复制uboot配置、dts到package/boot/uboot-rockchip
mkdir -p package/boot/uboot-rockchip/src/arch/arm/dts
mkdir -p package/boot/uboot-rockchip/src/configs
cp -f $GITHUB_WORKSPACE/FILES/dts/rk3566-roc-pc.dts package/boot/uboot-rockchip/src/arch/arm/dts/
cp -f $GITHUB_WORKSPACE/FILES/uboot-rockchip/rk3566-station-m2-u-boot.dtsi package/boot/uboot-rockchip/src/arch/arm/dts/
cp -f $GITHUB_WORKSPACE/FILES/uboot-rockchip/station-m2-rk3566_defconfig package/boot/uboot-rockchip/src/configs/

# 复制dts到files/arch/arm64/boot/dts/rockchip
mkdir -p target/linux/rockchip/files/arch/arm64/boot/dts/rockchip
cp -f $GITHUB_WORKSPACE/FILES/dts/rk3566-roc-pc.dts target/linux/rockchip/files/arch/arm64/boot/dts/rockchip/
# 添加设备⬆⬆⬆
# ============================================================================================================
