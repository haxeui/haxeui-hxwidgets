package haxe.ui.backend.hxwidgets.handlers;

import haxe.ui.backend.hxwidgets.handlers.NativeHandler;
import hx.widgets.StaticBoxSizer;

class FrameHandler extends NativeHandler {
    public override function resize(width:Int, height:Int) {
        var sizer = cast(_component.userData, StaticBoxSizer);
        sizer.staticBox.resize(width, height);
    }
}