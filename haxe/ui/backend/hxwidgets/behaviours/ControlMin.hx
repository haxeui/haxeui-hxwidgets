package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import hx.widgets.Slider;
import hx.widgets.SpinCtrl;

@:keep
class ControlMin extends DataBehaviour {
    public override function validateData() {
        if (_component.window == null) {
            return;
        }

        if ((_component.window is Slider)) {
            cast(_component.window, Slider).min = _value;
        } else if ((_component.window is SpinCtrl)) {
            cast(_component.window, SpinCtrl).min = _value;
        }
    }
    
    public override function get():Variant {
        if (_component == null || _component.window == null) {
            return 0;
        }
        return cast(_component.window, Slider).min;
        
        var v:Variant = null;
        if ((_component.window is Slider)) {
            v = cast(_component.window, Slider).min;
        } else if ((_component.window is SpinCtrl)) {
            v = cast(_component.window, SpinCtrl).min;
        }    
        return v;
    }
}
