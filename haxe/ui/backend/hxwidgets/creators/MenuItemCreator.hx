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

        
        var text = _component.text;
        var item:MenuItem = cast _component; // unsafe cast (on purpose)
        if (item != null && item.shortcutText != null) {
            text += "\t" + item.shortcutText;
        }
        
        if ((_component is MenuCheckBox)) {
            MenuItemHelper.set(id, item);
            menuItem = menu.appendCheckItem(id, text);
            menuItem.check(cast(_component, MenuCheckBox).selected);
        } else if ((_component is MenuOptionBox)) {
            MenuItemHelper.set(id, item);
            menuItem = menu.appendRadioItem(id, text);
            menuItem.check(cast(_component, MenuOptionBox).selected);
        } else if ((_component is MenuItem)) {
            MenuItemHelper.set(id, item);
            menuItem = menu.append(id, text);
        } else if ((_component is MenuSeparator)) {
            menuItem = menu.appendSeparator();
        }
        
        return menuItem;
    }
}