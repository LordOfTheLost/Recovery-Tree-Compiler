RECOVERY_TYPE=$1; DEVICE=$2; BUILD_TYPE=Monthly; BUILD_DATE="$( date +"%d.%m" ).21"; KERNEL="prebuilt/Image.tar.xz"
COMPILER="Compiler"
FOXRECOVERY="scripts/OFRP/vendor/recovery"
SHRPRECOVERY="scripts/SHRP/vendor/shrp"
SHRPSH="$SHRPRECOVERY/shrp_final.sh"
SHRPENVSH="scripts/SHRP/build/make/shrp/shrpEnv.sh"
FOXFILES="$FOXRECOVERY/FoxFiles"
SHRPFILES="$SHRPRECOVERY/extras"
FOXDEVICE="scripts/OFRP/device"
SHRPDEVICE="scripts/SHRP/device"
TWRPDEVICE="scripts/TWRP/device"
PBRPDEVICE="scripts/PBRP/device"
FOXFONTXML="scripts/OFRP/bootable/recovery/gui/theme/portrait_hdpi/themes/font.xml"
FOXADVANCEDXML="scripts/OFRP/bootable/recovery/gui/theme/portrait_hdpi/pages/advanced.xml"
FOXFILESXML="scripts/OFRP/bootable/recovery/gui/theme/portrait_hdpi/pages/files.xml"
FOXVARSXML="scripts/OFRP/bootable/recovery/gui/theme/portrait_hdpi/resources/vars.xml"
FOXINSTALLER="$FOXRECOVERY/installer/META-INF/com/google/android/update-binary"

Patch_OFRP_Settings() {
if [ ! -f $FOXRECOVERY/ADVANCEDXML ]; then sed -i "336,372 d" $FOXADVANCEDXML; touch $FOXRECOVERY/ADVANCEDXML; fi
sed -i "s/<placement x=\"%col1_x_caption%\" y=\"%row3_1a_y%\"\/>/<placement x=\"%col1_x_caption%\" y=\"%row5_1a_y%\"\/>/g" $FOXADVANCEDXML
sed -i "s/<placement x=\"0\" y=\"%row5_3_y%\" w=\"%screen_w%\" h=\"%bl_h4%\"\/>/<placement x=\"0\" y=\"%row5_2a_y%\" w=\"%screen_w%\" h=\"%bl_h4%\"\/>/g" $FOXADVANCEDXML
# sed -i "s/Roboto/GoogleSans/g" $FOXFONTXML; # sed -i "s/value=\"n\"/value=\"s\"/g" $FOXFONTXML
sed -i "s/<condition var1=\"of_hide_app_hint\" op=\"!=\" var2=\"1\"\/>/<condition var1=\"of_hide_app_hint\" op=\"!=\" var2=\"0\"\/>/g" $FOXADVANCEDXML
sed -i "/name=\"{@more}\"/I,+4 d" $FOXADVANCEDXML; sed -i "/name=\"{@hide}\"/I,+5 d" $FOXADVANCEDXML
sed -i "/<condition var1=\"utils_show\" var2=\"1\"\/>/d" $FOXADVANCEDXML
sed -i "/name=\"{@more}\"/I,+4 d" $FOXFILESXML; sed -i "/name=\"{@hide}\"/I,+5 d" $FOXFILESXML
sed -i "/<condition var1=\"opts_show\" var2=\"1\"\/>/d" $FOXFILESXML
sed -i "s/value=\"\/system\/app\"/value=\"notset\"/g" $FOXVARSXML
sed -i "s/value=\"\/system\/framework\"/value=\"notset\"/g" $FOXVARSXML
sed -i "s/value=\"\/data\/app\"/value=\"notset\"/g" $FOXVARSXML
sed -i "s/<variable name=\"clock_style\" value=\"0\" persist=\"1\"\/>/<variable name=\"clock_style\" value=\"1\" persist=\"1\"\/>/g" $FOXVARSXML
}

Default_OFRP_Settings() {
cp -f $COMPILER/maintainer.png scripts/OFRP/bootable/recovery/gui/theme/portrait_hdpi/images/Default/About
cp -f $COMPILER/busybox-$ARCH $FOXRECOVERY/Files/busybox
cp -f $COMPILER/unrootmagisk.zip $FOXFILES/unrootmagisk.zip
for f in "Magisk.zip" "GoogleSans.zip" "SubstratumRescue.zip" "SubstratumRescue_Legacy.zip" "OF_initd.zip" "AromaFM"; do if [ -f $FOXFILES/$f ] || [ -d $FOXFILES/$f ]; then rm -rf $FOXFILES/$f; fi; done
}

Default_OFRP_Vars() {
# Other Settings
#export FOX_R11=1; #DEPCRECATED!
#export FOX_ADVANCED_SECURITY=0; # This forces ADB and MTP to be disabled until after you enter the recovery (ie, until after all decryption/recovery passwords are successfully entered)
export OF_USE_TWRP_SAR_DETECT=0; # Blyad Prosto
export OF_SUPPORT_PRE_FLASH_SCRIPT=0; # Support running a script before flashing zips (other than ROMs). The script must be called /sbin/fox_pre_flash - toje blyad
#export OF_VANILLA_BUILD=1
export OF_CLASSIC_LEDS_FUNCTION=0; # Use the old R9.x Leds function
export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1; # If this is set, this script will also automatically set OF_USE_MAGISKBOOT to 1
#export OF_USE_MAGISKBOOT=1; # If OF_USE_MAGISKBOOT_FOR_ALL_PATCHES is on, then you don't need to turn it on 
export OF_FORCE_MAGISKBOOT_BOOT_PATCH_MIUI=1 # if you disable this, then enable the next line
#export OF_NO_MIUI_PATCH_WARNING=1
#export OF_USE_NEW_MAGISKBOOT=1; # OBSOLETE!
export OF_CHECK_OVERWRITE_ATTEMPTS=1; # Check for attempts by a ROM's installer to overwrite OrangeFox with another recovery
export FOX_RESET_SETTINGS=1
export OF_FLASHLIGHT_ENABLE=1
export FOX_DISABLE_APP_MANAGER=1
#export OF_NO_TREBLE_COMPATIBILITY_CHECK=1; # Disable checking for compatibility.zip in ROMs
export OF_RUN_POST_FORMAT_PROCESS=1

# BACKUP
export OF_SKIP_MULTIUSER_FOLDERS_BACKUP=0
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
export FOX_REMOVE_AAPT=1; # Used for FOX_DISABLE_APP MANAGER if on enable
export FOX_USE_BASH_SHELL=0
export FOX_ASH_IS_BASH=0
export FOX_USE_NANO_EDITOR=0
export FOX_USE_TAR_BINARY=0
#export FOX_USE_ZIP_BINARY=1; # OBSOLETE!
#export FOX_DELETE_MAGISK_ADDON=1
export FOX_USE_XZ_UTILS=0

# OTA for custom ROMs
export OF_SUPPORT_ALL_BLOCK_OTA_UPDATES=1; #This setting is incompatible with OF_DISABLE_MIUI_SPECIFIC_FEATURES/OF_TWRP_COMPATIBILITY_MODE/OF_VANILLA_BUILD
export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR=1
export OF_DISABLE_MIUI_OTA_BY_DEFAULT=1

# Encryption
export OF_PATCH_AVB20=1; # Patch AVB 2.0 so that OrangeFox is not replaced by stock recovery
export OF_OTA_RES_DECRYPT=1; # Decrypt internal storage (instead bailing out with an error) during MIUI OTA restore
export OF_DONT_PATCH_ENCRYPTED_DEVICE=1
export OF_KEEP_DM_VERITY=1
export OF_DISABLE_FORCED_ENCRYPTION=1
#export OF_KEEP_FORCED_ENCRYPTION=1

# Use system (ROM) fingerprint where available
#export OF_USE_SYSTEM_FINGERPRINT=1

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

# Compiler
export LC_ALL="C"
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
export FOX_USE_LZMA_COMPRESSION=1
#export OF_DISABLE_KEYMASTER2=1
#export OF_LEGACY_SHAR512=1
#export FOX_JAVA8_PATH="/usr/lib/jvm/java-8-openjdk/jre/bin/java

# Fox Version
export FOX_VERSION=R11.1-$VOFRP
export FOX_BUILD_TYPE=$BUILD_TYPE

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
for f in "Disable_Dm-Verity_ForceEncrypt.zip" "c_magisk.zip" "unmagisk.zip" "s_non_oms.zip" "s_oms.zip"; do if [ -f $FOXFILES/$f ] || [ -d $FOXFILES/$f ]; then rm -rf $SHRPFILES/$f; fi; done
cp -f $COMPILER/unrootmagisk.zip $SHRPFILES/unrootmagisk.zip
}

Build() {
case $DEVICE in
castor) VOFRP="$BUILD_DATE-(1)"; VSHRP="$BUILD_DATE-(1)"; ARCH="arm";;
beryllium) VOFRP="$BUILD_DATE-(13)"; VSHRP="$BUILD_DATE-(1)"; ARCH="arm64";;
dipper) VOFRP="$BUILD_DATE-(21)"; VSHRP="$BUILD_DATE-(1)"; ARCH="arm64";;
vince) VOFRP="$BUILD_DATE-(6)"; VSHRP="$BUILD_DATE-(1)"; ARCH="arm64";;
*) echo Please Write Device Name; exit 0;;
esac
case $RECOVERY_TYPE in
OFRP) Patch_OFRP_Settings; Default_OFRP_Settings; cd scripts/OFRP; Default_OFRP_Vars;;
SHRP) Patch_SHRP_Settings; Default_SHRP_Settings; cd scripts/SHRP;;
TWRP) cd scripts/TWRP;;
PBRP) cd scripts/PBRP;;
*) echo Please Write Recovery Name; exit 0;;
esac
if [ -f device/$DEVICE/$KERNEL ]; then tar -xf device/$DEVICE/$KERNEL -C device/$DEVICE/prebuilt; rm -f device/$DEVICE/$KERNEL; fi; if [ -f device/$DEVICE/$KERNEL ]; then tar -xf device/$DEVICE/$KERNEL -C device/$DEVICE/prebuilt; rm -f device/$DEVICE/$KERNEL; fi
# Compile it
export PLATFORM_VERSION="16.1.0"
export PLATFORM_SECURITY_PATCH="2099-12-31"
export ALLOW_MISSING_DEPENDENCIES=true
. build/envsetup.sh
add_lunch_combo omni_$DEVICE-eng
add_lunch_combo omni_$DEVICE-user
add_lunch_combo omni_$DEVICE-userdebug
lunch omni_$DEVICE-eng && mka recoveryimage
}

Build
exit 0
