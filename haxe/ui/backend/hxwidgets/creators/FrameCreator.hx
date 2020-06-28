package haxe.ui.backend.hxwidgets.creators;

import hx.widgets.Object;
import hx.widgets.Orientation;
import hx.widgets.Panel;
import hx.widgets.StaticBoxSizer;
import hx.widgets.Window;

@:keep
class FrameCreator extends Creator {
    public override function createWindow(parent:Object = null, style:Int = 0):Object {
        var panel = new Panel(cast(parent, Window), style);
        var sizer = new StaticBoxSizer(Orientation.VERTICAL, panel);
        _component.userData = sizer;
        return panel;
    }
}