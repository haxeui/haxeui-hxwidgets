package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import hx.widgets.Slider;

@:keep
class SliderTicks extends DataBehaviour {
    public override function validateData() {
        if (_component.window == null) {
            return;
        }

        if ((_component.window is Slider)) {
            cast(_component.window, Slider).tickFreq = _value;
        }
        
    }
    
    public override function get():Variant {
        if (_component == null || _component.window == null) {
            return 0;
        }
        
        var v:Variant = null;
        if ((_component.window is Slider)) {
            v = cast(_component.window, Slider).tickFreq;
        } 
        return v;
    }
}
