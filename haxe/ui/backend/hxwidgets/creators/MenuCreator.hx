package haxe.ui.backend.hxwidgets.creators;

import hx.widgets.Menu;
import hx.widgets.MenuBar;
import hx.widgets.Object;

class MenuCreator extends Creator {
    public override function createWindow(parent:Object = null, style:Int = 0):Object {
        var menu = new Menu(null, style);
        
        if (Std.is(parent, MenuBar)) {
            cast(parent, MenuBar).append(menu, _component.text);
        } else if (Std.is(parent, Menu)) {
            cast(parent, Menu).appendSubMenu(menu, _component.text);
        }
        
        return menu;
    }
}