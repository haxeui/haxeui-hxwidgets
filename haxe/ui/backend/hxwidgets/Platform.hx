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

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Util functions
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    public static var isWindows(get, null):Bool;
    private static function get_isWindows():Bool {
        return (name == "windows");
    }

    public static var isMac(get, null):Bool;
    private static function get_isMac():Bool {
        return (name == "mac");
    }

    public static var isLinux(get, null):Bool;
    private static function get_isLinux():Bool {
        return (name == "linux");
    }
    
}