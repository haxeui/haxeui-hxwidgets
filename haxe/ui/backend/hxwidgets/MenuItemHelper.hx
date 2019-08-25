package haxe.ui.backend.hxwidgets;
import haxe.ui.containers.menus.MenuItem;

class MenuItemHelper {
    private static var _menuItems:Map<Int, MenuItem> = new Map<Int, MenuItem>();

    public static function set(id:Int, item:MenuItem) {
        _menuItems.set(id, item);
    }
    
    public static function get(id:Int):MenuItem {
        return _menuItems.get(id);
    }
}