REPLACE="
/system/app/MIUISystemUIPlugin
/system/app/MiuiSystemUIPlugin
/system/app/MiuiSystemuiPlugin
/system/app/SystemUIPlugin
/system/app/SystemUIPlugin
/system/app/SystemuiPlugin
/system/product/app/MIUISystemUIPlugin
/system/product/app/MiuiSystemUIPlugin
/system/product/app/MiuiSystemuiPlugin
/system/product/app/SystemUIPlugin
/system/product/app/SystemUIPlugin
/system/product/app/SystemuiPlugin
"

SKIPUNZIP=1
SKIPMOUNT=false

install_files() {
    . $MODPATH/addon/install.sh

ui_print " "
ui_print " Warning: Miui 14 CN is not supported, read module post to know about installation."
ui_print " "
ui_print " "
ui_print "Let's start"
ui_print "Choose your Miui Version:"
ui_print "  Vol+ = Miui 13 or lower"
ui_print "  Vol- = Miui 14 Android 13 Xiaomi.eu based"
ui_print " "

if chooseport; then
    ui_print "- Miui 13 or lower selected"
    cp -rf $MODPATH/files/plugin/SystemUIPlugin.apk $MODPATH/system/app/aMiuiSystemUIPlugin
else
{
    ui_print "- Miui 14 Eu selected"
    cp -rf $MODPATH/files/plugin/SystemUIPlugin.apk $MODPATH/system/product/app/aMiuiSystemUIPlugin
}

fi

}

cleanup() {
	rm -rf $MODPATH/addon 2>/dev/null
	rm -rf $MODPATH/files 2>/dev/null
	rm -f $MODPATH/install.sh 2>/dev/null
	ui_print "- Deleting package cache files"
    rm -rf /data/resource-cache/*
    rm -rf /data/system/package_cache/*
    rm -rf /cache/*
    rm -rf /data/dalvik-cache/*
    ui_print "- Plugin updates will be uninstalled..."
    pm uninstall-system-updates miui.systemui.plugin
    ui_print "- Deleting old module (if it is installed)"
    touch /data/adb/modules/plugin_mod/remove
}

run_install() {
	ui_print " "
	unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH >&2
	ui_print " "
	ui_print "- Installing files"
	install_files
	sleep 1
	ui_print " "
	ui_print "- Cleaning up"
	ui_print " "
	cleanup
	sleep 1
	ui_print " "
	ui_print "- Removing any Plugin folder to avoid issues"
}

run_install