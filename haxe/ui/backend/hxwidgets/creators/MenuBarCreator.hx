package haxe.ui.backend.hxwidgets.creators;

import haxe.ui.core.Screen;
import hx.widgets.MenuBar;
import hx.widgets.Object;

@:access(haxe.ui.backend.ScreenImpl)
class MenuBarCreator extends Creator {
    public override function createWindow(parent:Object = null, style:Int = 0):Object {
        _component.includeInLayout = false;
        var menuBar = new MenuBar(style);
        Screen.instance.linkMenuBar(cast(_component, haxe.ui.containers.menus.MenuBar), menuBar);
        return menuBar;
    }
}