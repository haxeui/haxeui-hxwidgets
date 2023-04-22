package haxe.ui.backend.hxwidgets.builders;

import haxe.ui.core.CompositeBuilder;
import haxe.ui.core.Screen;

class MenuBuilder extends CompositeBuilder {
    public override function show():Bool {
        Screen.instance.addComponent(_component);
        return true;
    }
}