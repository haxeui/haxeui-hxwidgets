package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import hx.widgets.Gauge;
import hx.widgets.Slider;

@:keep
class ControlMax extends DataBehaviour {
    public override function validateData() {
        if (_component.window == null) {
            return;
        }

        if (Std.is(_component.window, Slider)) {
            cast(_component.window, Slider).max = _value;
        } else if (Std.is(_component.window, Gauge)) {
            cast(_component.window, Gauge).range = _value;
        }
    }
    
    public override function get():Variant {
        if (_component == null || _component.window == null) {
            return 0;
        }
        
        var v:Variant = null;
        if (Std.is(_component.window, Gauge)) {
            v = cast(_component.window, Gauge).range;
        } else if (Std.is(_component.window, Slider)) {
            v = cast(_component.window, Slider).max;
        }        
        return v;
    }
}