package haxe.ui.backend.hxwidgets.creators;

import hx.widgets.Menu;
import hx.widgets.Object;
import haxe.ui.containers.menus.MenuItem;
import haxe.ui.containers.menus.MenuCheckBox;
import haxe.ui.containers.menus.MenuOptionBox;
import haxe.ui.containers.menus.MenuSeparator;

class MenuItemCreator extends Creator {
    public override function createWindow(parent:Object = null, style:Int = 0):Object {
        var menu = cast(parent, Menu);
        var menuItem = null;
        
        var id = 0;
        if (_component.id != null) {
            id = ComponentImpl.hash(_component.id);
        }
        
        if (Std.is(_component, MenuItem)) {
            menuItem = menu.append(id, _component.text);
        } else if (Std.is(_component, MenuCheckBox)) {
            menuItem = menu.appendCheckItem(id, _component.text);
        } else if (Std.is(_component, MenuOptionBox)) {
            menuItem = menu.appendRadioItem(id, _component.text);
        } else if (Std.is(_component, MenuSeparator)) {
            menuItem = menu.appendSeparator();
        }
        
        return menuItem;
    }
}