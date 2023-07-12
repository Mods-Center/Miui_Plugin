AUTOMOUNT=true

support_verification(){
    Android=$(getprop ro.build.version.release)
    
    if [ "$(expr "$Android" '<' "12")" -ne 0 ]; then
        ui_print ""
        ui_print " Android version is not supported."
        ui_print ""
        exit 1
    fi
}

install_files() {
    . "$MODPATH/addon/install.sh"
    ui_print " READ!!! "
    ui_print " Signature verification must be disabled"
    ui_print " mandatory for MIUI 14 users based on" 
    ui_print " Android 13; otherwise, the module will"
    ui_print " not work. "
    ui_print ""
    ui_print " Select your preferred theme:"
    ui_print ""
    ui_print "  Vol+ = Transparent background"
    ui_print "  Vol- = Dark background"
    ui_print ""
    
    mkdir -p "$MODPATH/system/product/overlay"
    
    if chooseport; then
        ui_print "- Transparent background selected"
        cp -rf "$MODPATH/files/overlay/TransparentBG.apk" "$MODPATH/system/product/overlay"
    else
        ui_print "- Dark background selected"
        cp -rf "$MODPATH/files/overlay/DarkBG.apk" "$MODPATH/system/product/overlay"
    fi
    
    local plugin_package="miui.systemui.plugin"
    local plugin_path
    local plugin_folder
    local plugin_name
    
    pm uninstall-system-updates "$plugin_package"
    plugin_path=$(pm path "$plugin_package" | sed 's/package://')
    
    plugin_folder=$(dirname "$plugin_path" | sed 's/system//')
    plugin_name=$(basename "$plugin_path" | sed 's/.apk//')
    
    mv "$MODPATH/files/plugin/MiuiPluginMod.apk" "$MODPATH/files/plugin/$plugin_name.apk"
    
    mkdir -p "$MODPATH/system$plugin_folder"
    cp -f "$MODPATH/files/plugin/$plugin_name.apk" "$MODPATH/system$plugin_folder"
    
    mkdir -p "$MODPATH/system/app/PluginExtension"
    cp -f "$MODPATH/files/extension/PluginExtension.apk" "$MODPATH/system/app/PluginExtension"
}

set_permissions() {
    set_perm_recursive "$MODPATH" 0 0 0755 0644
}

cleanup() {
    rm -rf "$MODPATH/files" 2>/dev/null
    rm -rf "$MODPATH/addon" 2>/dev/null
    rm -rf "/data/resource-cache/*"
    rm -rf "/data/system/package_cache/*"
    rm -rf "/cache/*"
    rm -rf "/data/dalvik-cache/*"
    touch "$MODPATH/miui_plugin_mod/remove"
}

run_install() {
    unzip -o "$ZIPFILE" -x 'META-INF/*' -d "$MODPATH" >&2
    support_verification
    ui_print ""
    ui_print "- Installing files"
    ui_print ""
    install_files
    set_permissions
    sleep 1
    ui_print ""
    ui_print "- Cleaning up"
    ui_print ""
    cleanup
}

run_install
