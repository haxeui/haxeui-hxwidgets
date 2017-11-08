package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.Slider;

@:keep
class ControlMax extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        if (_component.window == null) {
            return;
        }

        if (Std.is(_component.window, Slider)) {
            cast(_component.window, Slider).max = value;
        }
    }
    
    public override function get():Variant {
        return cast(_component.window, Slider).max;
    }
}