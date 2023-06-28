REPLACE="
/system/app/MIUISystemUIPlugin
/system/app/MiuiSystemUIPlugin
/system/app/SystemUIPlugin
/system/product/app/MIUISystemUIPlugin
/system/product/app/MiuiSystemUIPlugin
/system/product/app/SystemUIPlugin
"

AUTOMOUNT=true

install_files() {
    . $MODPATH/addon/install.sh
ui_print " READ!!! "
ui_print " Signature verification must be disabled"
ui_print " mandatory for MIUI 14 users based on" 
ui_print " Android 13; otherwise, the module will"
ui_print " not work. "
ui_print " "
ui_print " "
ui_print " Select your preferred theme:"
ui_print " "
ui_print "  Vol+ = Transparent background"
ui_print "  Vol- = Dark background"
ui_print " "

if chooseport; then
    ui_print "- Transparent background selected"
    cp -rf $MODPATH/files/overlay/TransparentBG.apk $MODPATH/system/product/overlay
else
{
    ui_print "- Dark background selected"
    cp -rf $MODPATH/files/overlay/DarkBG.apk $MODPATH/system/product/overlay
}

fi

Android=`getprop ro.build.version.release`

if [ $Android = 12 ]; then
    ui_print " "
    ui_print " Android 12 detected"
    ui_print " "
    cp -rf $MODPATH/files/plugin/SystemUIPlugin.apk $MODPATH/system/app/MiuiSystemUIPlugin
elif [ $Android = 13 ]; then
    ui_print " "
	ui_print " Android 13 detected"
    ui_print " "
    cp -rf $MODPATH/files/plugin/SystemUIPlugin.apk $MODPATH/system/product/app/MiuiSystemUIPlugin
else 
{
    ui_print " Version not supported"
    ui_print " Exiting..."
    exit
}

fi

ui_print "- Plugin updates will be uninstalled..."
    pm uninstall-system-updates miui.systemui.plugin

TMPAPKDIR=/data/local/tmp
cp -rf $MODPATH/files/plugin/SystemUIPlugin.apk $TMPAPKDIR
result=$(pm install ${TMPAPKDIR}/SystemUIPlugin.apk 2>&1)
cp -rf $MODPATH/system/app/PluginExtension/PluginExtension.apk $TMPAPKDIR
result2=$(pm install ${TMPAPKDIR}/PluginExtension.apk 2>&1)

if [ $result = Success ] && [ $result2 = Success ];then
    ui_print " "
    ui_print " Signature verification disablement detected"
    ui_print " proceeding to install as an update."
    ui_print " Installed successfully."
    ui_print " Reboot is only needed for background color."
    ui_print " "
    ui_print " "
else
{
    ui_print " "
    ui_print " Signature verification disablement not detected"
    ui_print " proceeding with normal installation."
    ui_print " Reboot is needed."
    ui_print " "
    ui_print " "
}

fi
  
}

set_permissions() {
    set_perm_recursive  $MODPATH  0  0  0755  0644
}

cleanup() {
	rm -rf $MODPATH/files 2>/dev/null
	ui_print "- Deleting package cache files"
    rm -rf /data/resource-cache/*
    rm -rf /data/system/package_cache/*
    rm -rf /cache/*
    rm -rf /data/dalvik-cache/*
    ui_print "- Deleting old module (if it is installed)"
    touch /data/adb/modules/miui_plugin_mod/remove
}

run_install() {
    unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH >&2
	ui_print " "
	ui_print "- Installing files"
	ui_print " "
	install_files
	set_permissions
	sleep 1
	ui_print "- Cleaning up"
	ui_print " "
	cleanup
	sleep 1
	ui_print "- Removing any Plugin folder to avoid issues"
}

run_install