package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import hx.widgets.Slider;

@:keep
class ControlMin extends DataBehaviour {
    public override function validateData() {
        if (_component.window == null) {
            return;
        }

        if ((_component.window is Slider)) {
            cast(_component.window, Slider).min = _value;
        }
    }
    
    public override function get():Variant {
        if (_component == null || _component.window == null) {
            return 0;
        }
        return cast(_component.window, Slider).min;
    }
}