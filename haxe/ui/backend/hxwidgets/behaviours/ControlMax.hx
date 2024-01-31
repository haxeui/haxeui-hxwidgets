package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import hx.widgets.Gauge;
import hx.widgets.Slider;
import hx.widgets.SpinCtrl;
import hx.widgets.SpinCtrlDouble;

@:keep
class ControlMax extends DataBehaviour {
    public override function validateData() {
        if (_component.window == null) {
            return;
        }

        if ((_component.window is Slider)) {
            cast(_component.window, Slider).max = _value;
        } else if ((_component.window is Gauge)) {
            cast(_component.window, Gauge).range = _value;
        }  else if ((_component.window is SpinCtrl)) {
            cast(_component.window, SpinCtrl).max = _value;
        }  else if ((_component.window is SpinCtrlDouble)) {
            cast(_component.window, SpinCtrlDouble).max = _value;
        }
        
    }
    
    public override function get():Variant {
        if (_component == null || _component.window == null) {
            return 0;
        }
        
        var v:Variant = null;
        if ((_component.window is Gauge)) {
            v = cast(_component.window, Gauge).range;
        } else if ((_component.window is Slider)) {
            v = cast(_component.window, Slider).max;
        } else if ((_component.window is SpinCtrl)) {
            v = cast(_component.window, SpinCtrl).max;
        } else if ((_component.window is SpinCtrlDouble)) {
            v = cast(_component.window, SpinCtrlDouble).max;
        }        
        return v;
    }
}
