package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.Slider;

@:keep
class ControlMin extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        if (_component.window == null) {
            return;
        }

        if (Std.is(_component.window, Slider)) {
            /*
            var slider:haxe.ui.components.Slider = cast(_component, haxe.ui.components.Slider);
            var wxSlider:Slider = cast(_component.window, Slider);
            trace(">>>>>>>>>>>>>>>> min: " + value + " max: " + wxSlider.max);
            if (value > wxSlider.max) {
                wxSlider.max = value;
                trace("CACHE!");
            }
            */
            
            
            cast(_component.window, Slider).min = value;
        }
    }
    
    public override function get():Variant {
        return cast(_component.window, Slider).min;
    }
}