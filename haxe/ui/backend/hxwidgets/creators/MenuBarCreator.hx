package haxe.ui.backend.hxwidgets.creators;

import haxe.ui.core.Screen;
import hx.widgets.MenuBar;
import hx.widgets.Object;

class MenuBarCreator extends Creator {
    public override function createWindow(parent:Object = null, style:Int = 0):Object {
        _component.includeInLayout = false;
        var menuBar = new MenuBar(style);
        Screen.instance.frame.menuBar = menuBar;
        return menuBar;
    }
}