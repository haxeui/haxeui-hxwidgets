package haxe.ui.backend.hxwidgets;

import hx.widgets.OperatingSystemId;
import hx.widgets.PlatformInfo;

class Platform {
    private static var _name:String;
    public static var name(get, null):String;
    private static function get_name():String {
        if (_name == null) {
            var info:PlatformInfo = new PlatformInfo();
            if (info.isMac) {
                _name = "mac";
            } else if (info.isLinux) {
                _name = "linux";
            } else if (info.isWindows) {
                _name = "windows";
            }
        }
        return _name;
    }

}