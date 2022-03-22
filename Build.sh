RECOVERY_TYPE=$1; DEVICE=$2; VARIANT=$3; BUILD_TYPE=Monthly; BUILD_DATE="$( date +"%d.%m" ).22"; KERNEL="prebuilt/Image.tar.xz"
OFRP=false; SHRP=false; TWRP=false; PBRP=false
if [ -d OFRP ]; then FPOFRP=OFRP; OFRP=true; else FPOFRP=scripts/OFRP; fi
if [ -d SHRP ]; then FPSHRP=SHRP; SHRP=true; else FPSHRP=scripts/SHRP; fi
if [ -d TWRP ]; then FPTWRP=TWRP; TWRP=true; else FPTWRP=scripts/TWRP; fi
if [ -d PBRP ]; then FPPBRP=PBRP; PBRP=true; else FPPBRP=scripts/PBRP; fi
COMPILER="Compiler"
OFRPRECOVERY="$FPOFRP/vendor/recovery"
SHRPRECOVERY="$FPSHRP/vendor/shrp"
SHRPSH="$SHRPRECOVERY/shrp_final.sh"
SHRPENVSH="$FPSHRP/build/make/shrp/shrpEnv.sh"
OFRPFILES="$OFRPRECOVERY/FoxFiles"
SHRPFILES="$SHRPRECOVERY/extras"
OFRPDEVICE="$FPOFRP/device"
SHRPDEVICE="$FPSHRP/device"
TWRPDEVICE="$FPTWRP/device"
PBRPDEVICE="$FPPBRP/device"
OFRPLANGUAGES="$FPOFRP/bootable/recovery/gui/theme/common/languages"
OFRPFONTXML="$FPOFRP/bootable/recovery/gui/theme/portrait_hdpi/themes/font.xml"
OFRPADVANCEDXML="$FPOFRP/bootable/recovery/gui/theme/portrait_hdpi/pages/advanced.xml"
OFRPFILESXML="$FPOFRP/bootable/recovery/gui/theme/portrait_hdpi/pages/files.xml"
OFRPVARSXML="$FPOFRP/bootable/recovery/gui/theme/portrait_hdpi/resources/vars.xml"
OFRPINSTALLER="$OFRPRECOVERY/installer/META-INF/com/google/android/update-binary"
OFRPSDK="$FPOFRP/build/make/core/version_defaults.mk"
OFRPCONF="$FPOFRP/build/make/core/config.mk"

Patch_OFRP_Settings() {
if [ ! -f $OFRPRECOVERY/ADVANCEDXML ]; then sed -i "351,387 d" $OFRPADVANCEDXML; touch $OFRPRECOVERY/ADVANCEDXML; fi
# sed -i "s/<placement x=\"%col1_x_caption%\" y=\"%row3_1a_y%\"\/>/<placement x=\"%col1_x_caption%\" y=\"%row4_1a_y%\"\/>/g" $OFRPADVANCEDXML
# sed -i "s/<placement x=\"0\" y=\"%row5_3_y%\" w=\"%screen_w%\" h=\"%bl_h4%\"\/>/<placement x=\"0\" y=\"%row4_2a_y%\" w=\"%screen_w%\" h=\"%bl_h4%\"\/>/g" $OFRPADVANCEDXML
# sed -i "s/Roboto/GoogleSans/g" $OFRPFONTXML; # sed -i "s/value=\"n\"/value=\"s\"/g" $OFRPFONTXML
sed -i "s/<condition var1=\"of_hide_app_hint\" op=\"!=\" var2=\"1\"\/>/<condition var1=\"of_hide_app_hint\" op=\"!=\" var2=\"0\"\/>/g" $OFRPADVANCEDXML
sed -i "/name=\"{@more}\"/I,+4 d" $OFRPADVANCEDXML; sed -i "/name=\"{@hide}\"/I,+5 d" $OFRPADVANCEDXML
sed -i "/<condition var1=\"utils_show\" var2=\"1\"\/>/d" $OFRPADVANCEDXML
sed -i "/name=\"{@more}\"/I,+4 d" $OFRPFILESXML; sed -i "/name=\"{@hide}\"/I,+5 d" $OFRPFILESXML
sed -i "/<condition var1=\"opts_show\" var2=\"1\"\/>/d" $OFRPFILESXML
sed -i "s/value=\"\/system\/app\"/value=\"notset\"/g" $OFRPVARSXML
sed -i "s/value=\"\/system\/framework\"/value=\"notset\"/g" $OFRPVARSXML
sed -i "s/value=\"\/data\/app\"/value=\"notset\"/g" $OFRPVARSXML
sed -i "s/<variable name=\"clock_style\" value=\"0\" persist=\"1\"\/>/<variable name=\"clock_style\" value=\"1\" persist=\"1\"\/>/g" $OFRPVARSXML
for tr in $(ls $OFRPLANGUAGES); do
sed -i "s/<string name=\"dalvik\">Dalvik \/ ART Cache<\/string>/<string name=\"dalvik\">Dalvik\/ART Cache<\/string>/g" $OFRPLANGUAGES/$tr
sed -i "s/<string name=\"system_image\">System (образ)<\/string>/<string name=\"system_image\">System Образ<\/string>/g" $OFRPLANGUAGES/$tr
sed -i "s/<string name=\"system_image\">System (Образ)<\/string>/<string name=\"system_image\">System Образ<\/string>/g" $OFRPLANGUAGES/$tr
sed -i "s/<string name=\"vendor_image\">Vendor (образ)<\/string>/<string name=\"vendor_image\">Vendor Образ<\/string>/g" $OFRPLANGUAGES/$tr
sed -i "s/<string name=\"vendor_image\">Vendor (Образ)<\/string>/<string name=\"vendor_image\">Vendor Образ<\/string>/g" $OFRPLANGUAGES/$tr
done
if [ $NEWV != true ]; then sed -i "s/28/29/g" $OFRPSDK; sed -i "s/sepolicy_major_vers := 28/sepolicy_major_vers := 29/g" $OFRPCONF; fi
}

Default_OFRP_Settings() {
cp -f $COMPILER/maintainer.png $FPOFRP/bootable/recovery/gui/theme/portrait_hdpi/images/Default/About
cp -f $COMPILER/busybox-$ARCH $OFRPRECOVERY/Files/busybox
cp -f $COMPILER/unrootmagisk.zip $OFRPFILES/unrootmagisk.zip
for f in "Magisk.zip" "GoogleSans.zip" "SubstratumRescue.zip" "SubstratumRescue_Legacy.zip" "OF_initd.zip" "AromaFM"; do if [ -f $OFRPFILES/$f ] || [ -d $OFRPFILES/$f ]; then rm -rf $OFRPFILES/$f; fi; done
}

Default_OFRP_Vars() {
# Other Settings
#export FOX_R11=1; #OBSOLETE
export FOX_ADVANCED_SECURITY=0; # This forces ADB and MTP to be disabled until after you enter the recovery (ie, until after all decryption/recovery passwords are successfully entered)
export OF_USE_TWRP_SAR_DETECT=0; # OBSOLETE
export OF_SUPPORT_PRE_FLASH_SCRIPT=0; # OBSOLETE
#export OF_VANILLA_BUILD=1
export OF_CLASSIC_LEDS_FUNCTION=0; # Use the old R9.x Leds function
export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1; # If this is set, this script will also automatically set OF_USE_MAGISKBOOT to 1
#export OF_USE_MAGISKBOOT=1; # If OF_USE_MAGISKBOOT_FOR_ALL_PATCHES is on, then you don't need to turn it on 
export OF_FORCE_MAGISKBOOT_BOOT_PATCH_MIUI=1 # if you disable this, then enable the next line
#export OF_NO_MIUI_PATCH_WARNING=1
#export OF_USE_NEW_MAGISKBOOT=1; # OBSOLETE
export OF_CHECK_OVERWRITE_ATTEMPTS=1; # Check for attempts by a ROM's installer to overwrite OrangeFox with another recovery
export FOX_RESET_SETTINGS=1
export OF_FLASHLIGHT_ENABLE=1
export FOX_ENABLE_APP_MANAGER=0
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1; # Disable checking for compatibility.zip in ROMs
#export OF_RUN_POST_FORMAT_PROCESS=1; # DEPRECATED

# BACKUP
export OF_SKIP_MULTIUSER_FOLDERS_BACKUP=0; # OBSOLETE
case $DEVICE in
beryllium) export OF_QUICK_BACKUP_LIST="/boot;/data;/system_root;/vendor;";;
dipper) export OF_QUICK_BACKUP_LIST="/boot;/data;/system_root;/vendor;";;
*) export OF_QUICK_BACKUP_LIST="/boot;/data;/system;/vendor;";;
esac

# Files
export FOX_USE_GREP_BINARY=0
export FOX_DELETE_AROMAFM=1
export FOX_DELETE_INITD_ADDON=1
export FOX_REPLACE_BUSYBOX_PS=1
#export FOX_REMOVE_BUSYBOX_BINARY=0
export FOX_REMOVE_AAPT=1; # Used for FOX_DISABLE_APP MANAGER if on enable
export FOX_USE_BASH_SHELL=0
export FOX_ASH_IS_BASH=0
export FOX_USE_NANO_EDITOR=0
export FOX_USE_TAR_BINARY=0
#export FOX_USE_ZIP_BINARY=1; # OBSOLETE
#export FOX_DELETE_MAGISK_ADDON=1
export FOX_USE_XZ_UTILS=0
export OF_ENABLE_LPTOOLS=0; # This requires syncing the lptools sources (just run "repo sync" from the usual place, or follow the instructions in the error message that will be generated if the sources are missing)
#export FOX_USE_SPECIFIC_MAGISK_ZIP=/Xlaomi/Govno.zip
#export FOX_BUILD_BASH=0
#export FOX_EXCLUDE_NANO_EDITOR=0
export FOX_USE_SED_BINARY=0

# OTA for custom ROMs
export OF_SUPPORT_ALL_BLOCK_OTA_UPDATES=1; #This setting is incompatible with OF_DISABLE_MIUI_SPECIFIC_FEATURES/OF_TWRP_COMPATIBILITY_MODE/OF_VANILLA_BUILD
export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR=1
export OF_DISABLE_MIUI_OTA_BY_DEFAULT=1

# Encryption
export OF_PATCH_AVB20=1; # Patch AVB 2.0 so that OrangeFox is not replaced by stock recovery
export OF_OTA_RES_DECRYPT=0; # Decrypt internal storage (instead bailing out with an error) during MIUI OTA restore
#export OF_DONT_PATCH_ENCRYPTED_DEVICE=1; # Set to 1 to avoid applying the forced-encryption patches on encrypted devices
#export OF_KEEP_DM_VERITY=1; # Set to 1 to *UNTICK* the OrangeFox "Disable DM-Verity" box on every bootup
export OF_FORCE_DISABLE_DM_VERITY_FORCED_ENCRYPTION=1; # Set to 1 to **TICK** both the OrangeFox "Disable DM-Verity" and "Disable Forced Encryption" boxes on every bootup
#export OF_KEEP_DM_VERITY_FORCED_ENCRYPTION=1; # Set to 1 to *UNTICK* both the OrangeFox "Disable DM-Verity" and "Disable Forced Encryption" boxes on every bootup
#export OF_FORCE_DISABLE_FORCED_ENCRYPTION=1; # Set to 1 to **TICK** the OrangeFox "Disable Forced Encryption" box on every bootup
#export OF_KEEP_FORCED_ENCRYPTION=1; # Set to 1 to *UNTICK* the OrangeFox "Disable Forced Encryption" box on every bootup
#export OF_DISABLE_FORCED_ENCRYPTION=1; # Set to 1 to **TICK** the OrangeFox "Disable Forced Encryption" box by default (on fresh installation)
#export OF_DISABLE_DM_VERITY=1; # Set to 1 to **TICK** the OrangeFox "Disable DM-Verity" box by default (on fresh installation)
#export OF_FORCE_DISABLE_DM_VERITY=1; # Set to 1 to **TICK** the OrangeFox "Disable DM-Verity" box by default (on fresh installation)
export OF_DISABLE_DM_VERITY_FORCED_ENCRYPTION=1; # Set to 1 to **TICK** both the OrangeFox "Disable DM-Verity" and "Disable Forced Encryption" boxes by default (on fresh installation)
export OF_SKIP_DECRYPTED_ADOPTED_STORAGE=1; # Set to 1 to skip adopted storage decryption (only kicks in if the installed ROM is higher than Android 11 and can prevent certain A12 bootloops)
#export OF_NEW_MAGISKBOOT_FORCE_AVB_VERIFY=1; # OBSOLETE
export OF_SKIP_FBE_DECRYPTION=1; # Set to 1 to skip the FBE decryption routines (prevents hanging at the Fox logo or Redmi/Mi logo)
#export OF_SKIP_FBE_DECRYPTION_SDKVERSION=31


# Use system (ROM) fingerprint where available
#export OF_USE_SYSTEM_FINGERPRINT=1; # OBSOLETE

# UI
export OF_CLOCK_POS=0
export OF_USE_LOCKSCREEN_BUTTON=1
case $DEVICE in
castor) export OF_SCREEN_H=1920; export OF_STATUS_H=80;;
beryllium) export OF_SCREEN_H=2246; export OF_STATUS_H=90;;
dipper) export OF_SCREEN_H=2248; export OF_STATUS_H=90;;
vince) export OF_SCREEN_H=2160; export OF_STATUS_H=80;;
*) echo Please Write Device Name; exit 0;;
esac
export OF_STATUS_INDENT_LEFT=48
export OF_STATUS_INDENT_RIGHT=48
#export OF_NO_SPLASH_CHANGE=1
#export OF_DISABLE_EXTRA_ABOUT_PAGE=1

# DEBUG MODE
export FOX_INSTALLER_DEBUG_MODE=0
export OF_DONT_KEEP_LOG_HISTORY=0

# Compiler
export LC_ALL="C"
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1; # OBSOLETE
export FOX_USE_LZMA_COMPRESSION=1
#export OF_DISABLE_KEYMASTER2=1; # OBSOLETE
#export OF_LEGACY_SHAR512=1
#export FOX_JAVA8_PATH="/usr/lib/jvm/java-8-openjdk/jre/bin/java
export OF_DISABLE_UPDATEZIP=0

# Fox Version
export FOX_VERSION=R11.1-$VOFRP
export FOX_BUILD_TYPE=$BUILD_TYPE
# export FOX_VARIANT=Otval

# CUMTAINER
export OF_MAINTAINER="Lord Of The Lost"
}

Patch_SHRP_Settings() {
sed -i "s/ZIP_NAME=SHRP_v\${SHRP_VERSION}_\${SHRP_STATUS}-\${XSTATUS}_\$SHRP_DEVICE-\$SHRP_BUILD_DATE/ZIP_NAME=\"SHRP-V\${SHRP_VERSION}-$VSHRP-$BUILD_TYPE-\$SHRP_DEVICE\"/g" $SHRPSH
sed -i "s/ADDON_ZIP_NAME=SHRP_AddonRescue_v\${SHRP_VERSION}_\$SHRP_DEVICE-\$SHRP_BUILD_DATE/ADDON_ZIP_NAME=\"SHRP-AddonRescue-V\${SHRP_VERSION}-$VSHRP-\$SHRP_DEVICE\"/g" $SHRPSH
sed -i "s/\"buildNo\": \"\$SHRP_BUILD_DATE\"/\"buildNo\": \"$BUILD_DATE\"/g" $SHRPSH
sed -i "s/SHRP_STATUS=stable/SHRP_STATUS=Stable/g" $SHRPENVSH
sed -i "s/XSTATUS=Official/XSTATUS=$BUILD_TYPE/g" $SHRPENVSH; sed -i "s/XSTATUS=Unofficial/XSTATUS=$BUILD_TYPE/g" $SHRPENVSH
}

Default_SHRP_Settings() {
for f in "Disable_Dm-Verity_ForceEncrypt.zip" "c_magisk.zip" "unmagisk.zip" "s_non_oms.zip" "s_oms.zip"; do if [ -f $SHRPFILES/$f ] || [ -d $SHRPFILES/$f ]; then rm -rf $SHRPFILES/$f; fi; done
cp -f $COMPILER/unrootmagisk.zip $SHRPFILES
}

Build() {
case $VARIANT in
N) NEWV=true;;
O) NEWV=false;;
*) echo Please Write Recovery Variant!; exit 0;;
esac
case $DEVICE in
castor) VOFRP="$BUILD_DATE-(1)"; VSHRP="$BUILD_DATE-(1)"; ARCH="arm";;
beryllium) VOFRP="$BUILD_DATE-(17)"; VSHRP="$BUILD_DATE-(1)"; ARCH="arm64";;
dipper) VOFRP="$BUILD_DATE-(25)"; VSHRP="$BUILD_DATE-(1)"; ARCH="arm64";;
vince) VOFRP="$BUILD_DATE-(10)"; VSHRP="$BUILD_DATE-(1)"; ARCH="arm64";;
*) echo Please Write Device Code Name!; exit 0;;
esac
case $RECOVERY_TYPE in
OFRP) mkdir -p $OFRPDEVICE; Patch_OFRP_Settings; Default_OFRP_Settings; cd $FPOFRP; Default_OFRP_Vars;;
SHRP) mkdir -p $SHRPDEVICE; Patch_SHRP_Settings; Default_SHRP_Settings; cd $FPSHRP;;
TWRP) mkdir -p $TWRPDEVICE; cd $FPTWRP;;
PBRP) mkdir -p $PBRPDEVICE; cd $FPPBRP;;
*) echo Please Write Recovery Name!; exit 0;;
esac
if [ -f device/$DEVICE/$KERNEL ]; then tar -xf device/$DEVICE/$KERNEL -C device/$DEVICE/prebuilt; rm -f device/$DEVICE/$KERNEL; fi; if [ -f device/$DEVICE/$KERNEL ]; then tar -xf device/$DEVICE/$KERNEL -C device/$DEVICE/prebuilt; rm -f device/$DEVICE/$KERNEL; fi
export PLATFORM_VERSION="16.1.0"
export PLATFORM_SECURITY_PATCH="2099-12-31"
if [ $OFRP != true ]; then
export PLATFORM_VNDK_VERSION="29"
export PLATFORM_SYSTEMSDK_MIN_VERSION="29"
export PLATFORM_SDK_VERSION="29"
fi
export ALLOW_MISSING_DEPENDENCIES=true
if $NEWV; then
if [ -f device/$DEVICE/omni_$DEVICE.mk ]; then
mv device/$DEVICE/omni_$DEVICE.mk device/$DEVICE/twrp_$DEVICE.mk
sed -i "s/omni_$DEVICE/twrp_$DEVICE/g" device/$DEVICE/twrp_$DEVICE.mk
sed -i "s/\$(call inherit-product, build\/target\/product\/embedded.mk)/\$(call inherit-product, build\/make\/target\/product\/aosp_base.mk)/g" device/$DEVICE/twrp_$DEVICE.mk
sed -i "s/\$(call inherit-product, vendor\/omni\/config\/common.mk)/\$(call inherit-product, vendor\/twrp\/config\/common.mk)/g" device/$DEVICE/twrp_$DEVICE.mk
sed -i "s/omni_$DEVICE.mk/twrp_$DEVICE.mk/g" device/$DEVICE/AndroidProducts.mk
if [ -f device/$DEVICE/recovery.fstab ]; then
sed -i "s/TARGET_RECOVERY_FSTAB := \$(LOCAL_PATH)\/recovery.fstab/\#TARGET_RECOVERY_FSTAB := \$(LOCAL_PATH)\/recovery.fstab/g" device/$DEVICE/BoardConfig.mk
mkdir -p device/$DEVICE/recovery/root/system/etc
mv device/$DEVICE/recovery.fstab device/$DEVICE/recovery/root/system/etc/twrp.fstab
fi
fi
source build/envsetup.sh
lunch twrp_$DEVICE-eng && mka recoveryimage
else
if [ -f device/$DEVICE/twrp_$DEVICE.mk ]; then
mv device/$DEVICE/twrp_$DEVICE.mk device/$DEVICE/omni_$DEVICE.mk
sed -i "s/twrp_$DEVICE/omni_$DEVICE/g" device/$DEVICE/omni_$DEVICE.mk
sed -i "s/\$(call inherit-product, build\/make\/target\/product\/aosp_base.mk)/\$(call inherit-product, build\/target\/product\/embedded.mk)/g" device/$DEVICE/omni_$DEVICE.mk
sed -i "s/\$(call inherit-product, vendor\/twrp\/config\/common.mk)/\$(call inherit-product, vendor\/omni\/config\/common.mk)/g" device/$DEVICE/omni_$DEVICE.mk
sed -i "s/twrp_$DEVICE.mk/omni_$DEVICE.mk/g" device/$DEVICE/AndroidProducts.mk
fi
. build/envsetup.sh
lunch omni_$DEVICE-eng && mka recoveryimage
fi
}

Build
exit 0
