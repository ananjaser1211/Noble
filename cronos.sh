#!/bin/bash
#
# Cronos Build Script
# For Exynos7420
# Coded by BlackMesa/AnanJaser1211 @2018
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software

# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Directory Contol
CR_DIR=$(pwd)
CR_TC=/home/elite_aj1211/Android/Toolchains/aarch64-linux-android-4.9/bin/aarch64-linux-android-
CR_DTS=arch/arm64/boot/dts
CR_OUT=$CR_DIR/Helios/Out
CR_AIK=$CR_DIR/Helios/A.I.K
CR_RAMDISK=$CR_DIR/Helios/Ramdisk
CR_KERNEL=$CR_DIR/arch/arm64/boot/Image
CR_DTB=$CR_DIR/boot.img-dtb
# Kernel Variables
CR_VERSION=V1.0
CR_NAME=Helios_Kernel
CR_JOBS=5
CR_ANDROID=o
CR_PLATFORM=8.0.0
CR_ARCH=arm64
CR_DATE=$(date +%Y%m%d)
# Init build
export CROSS_COMPILE=$CR_TC
export ANDROID_MAJOR_VERSION=$CR_ANDROID
export PLATFORM_VERSION=$CR_PLATFORM
export $CR_ARCH
##########################################
# Device specific Variables [SM-N920C]
CR_DTSFILES_N920C="exynos7420-noblelte_eur_open_00.dtb exynos7420-noblelte_eur_open_01.dtb exynos7420-noblelte_eur_open_02.dtb exynos7420-noblelte_eur_open_03.dtb exynos7420-noblelte_eur_open_04.dtb exynos7420-noblelte_eur_open_05.dtb exynos7420-noblelte_eur_open_06.dtb exynos7420-noblelte_eur_open_08.dtb exynos7420-noblelte_eur_open_09.dtb"
CR_CONFG_N920C=exynos7420-noblelte_defconfig
CR_VARIANT_N920C=N920C
# Device specific Variables [SM-]
CR_DTSFILES_=""
CR_CONFG_=
CR_VARIANT_=
#####################################################

# Script functions
CLEAN_SOURCE()
{
echo "----------------------------------------------"
echo " "
echo "Cleaning"
#make clean
#make mrproper
# rm -r -f $CR_OUT/*
rm -r -f $CR_DTB
rm -rf $CR_DTS/.*.tmp
rm -rf $CR_DTS/.*.cmd
rm -rf $CR_DTS/*.dtb
echo " "
echo "----------------------------------------------"	
}
BUILD_ZIMAGE()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building zImage for $CR_VARIANT"
	export LOCALVERSION=-$CR_NAME-$CR_VERSION-$CR_VARIANT-$CR_DATE
	make  $CR_CONFG
	make -j$CR_JOBS
	echo " "
	echo "----------------------------------------------"
}
BUILD_DTB()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building DTB for $CR_VARIANT"
	export $CR_ARCH
	export CROSS_COMPILE=$CR_TC
	export ANDROID_MAJOR_VERSION=$CR_ANDROID
	make  $CR_CONFG
	make $CR_DTSFILES
	./scripts/dtbTool/dtbTool -o ./boot.img-dtb -d $CR_DTS/ -s 2048
	du -k "./boot.img-dtb" | cut -f1 >sizT
	sizT=$(head -n 1 sizT)
	rm -rf sizT
	echo "Combined DTB Size = $sizT Kb"
	rm -rf $CR_DTS/.*.tmp
	rm -rf $CR_DTS/.*.cmd
	rm -rf $CR_DTS/*.dtb
	echo " "
	echo "----------------------------------------------"
}
PACK_BOOT_IMG()
{
	echo "----------------------------------------------"
	echo " "
	echo "Building Boot.img for $CR_VARIANT"
	cp -rf $CR_RAMDISK/* $CR_AIK
	mv $CR_KERNEL $CR_AIK/split_img/boot.img-zImage
	mv $CR_DTB $CR_AIK/split_img/boot.img-dtb
	$CR_AIK/repackimg.sh
	echo -n "SEANDROIDENFORCE" » $CR_AIK/image-new.img
	mv $CR_AIK/image-new.img $CR_OUT/$CR_NAME-$CR_VERSION-$CR_DATE-$CR_VARIANT.img
	$CR_AIK/cleanup.sh
}
# Main Menu
clear
echo "----------------------------------------------"
echo "$CR_NAME $CR_VERSION Build Script"
echo "----------------------------------------------"
PS3='Please select your option (1-2): '
menuvar=("SM-N920C" "Exit")
select menuvar in "${menuvar[@]}"
do
    case $menuvar in
        "SM-N920C")
            clear
            CLEAN_SOURCE
            echo "Starting $CR_VARIANT_N920C kernel build..."
            CR_VARIANT=$CR_VARIANT_N920C
            CR_CONFG=$CR_CONFG_N920C
            CR_DTSFILES=$CR_DTSFILES_N920C
            BUILD_ZIMAGE
            BUILD_DTB
            PACK_BOOT_IMG
            echo " "
            echo "----------------------------------------------"
            echo "$CR_VARIANT kernel build finished."
            echo "$CR_VARIANT Ready at $CR_OUT"
            echo "Combined DTB Size = $sizT Kb"
            echo "Press Any key to end the script"
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
    "Exit")
            break
            ;;
        *) echo Invalid option.;;
    esac
done
