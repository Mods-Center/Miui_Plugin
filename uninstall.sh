#!/system/bin/sh
rm -rf /data/resource-cache/*
rm -rf /data/system/package_cache/*
rm -rf /cache/*
rm -rf /data/dalvik-cache/*
pm uninstall com.kashi.pluginExt
pm uninstall-system-updates miui.systemui.plugin