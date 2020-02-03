package haxe.ui.backend.hxwidgets.builders;

import haxe.ui.core.CompositeBuilder;
import haxe.ui.core.Screen;
import hx.widgets.Menu;

class MenuBuilder extends CompositeBuilder {
    public override function show():Bool {
        var frame = Screen.instance.frame;
        var menu = cast(_component.object, Menu);
        frame.popupMenu(menu);
        return true;
    }
}