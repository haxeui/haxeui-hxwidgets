package haxe.ui.backend.hxwidgets.creators;

import hx.widgets.Menu;
import hx.widgets.Object;
import haxe.ui.containers.menus.MenuItem;
import haxe.ui.containers.menus.MenuCheckBox;
import haxe.ui.containers.menus.MenuOptionBox;
import haxe.ui.containers.menus.MenuSeparator;

class MenuItemCreator extends Creator {
    private static var _menuId:Int = 1;
    public override function createWindow(parent:Object = null, style:Int = 0):Object {
        var menu = cast(parent, Menu);
        var menuItem = null;
        
        var id = _menuId;
        _menuId++;
        
        if (Std.is(_component, MenuCheckBox)) {
            MenuItemHelper.set(id, cast(_component, MenuItem));
            menuItem = menu.appendCheckItem(id, _component.text);
        } else if (Std.is(_component, MenuOptionBox)) {
            MenuItemHelper.set(id, cast(_component, MenuItem));
            menuItem = menu.appendRadioItem(id, _component.text);
        } else if (Std.is(_component, MenuItem)) {
            MenuItemHelper.set(id, cast(_component, MenuItem));
            menuItem = menu.append(id, _component.text);
        } else if (Std.is(_component, MenuSeparator)) {
            menuItem = menu.appendSeparator();
        }
        
        return menuItem;
    }
}