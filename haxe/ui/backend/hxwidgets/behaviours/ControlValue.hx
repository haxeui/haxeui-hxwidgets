package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.CheckBox;
import hx.widgets.Control;
import hx.widgets.Gauge;
import hx.widgets.RadioButton;
import hx.widgets.ScrollBar;
import hx.widgets.Slider;

@:keep
class ControlValue extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        
        if (_component.window == null) {
            return;
        }
        
        if (Std.is(_component.window, Gauge)) {
            cast(_component.window, Gauge).value = value;
        } else if (Std.is(_component.window, Slider)) {
            cast(_component.window, Slider).value = value;
        } else if (Std.is(_component.window, ScrollBar)) {
            var scroll:ScrollBar = cast(_component.window, ScrollBar);
            scroll.setScrollbar(value, scroll.thumbSize, scroll.range, scroll.pageSize);
        } else if (Std.is(_component.window, CheckBox)) {
            cast(_component.window, CheckBox).value = value;
        } else if (Std.is(_component.window, RadioButton)) {
            cast(_component.window, RadioButton).value = value;
        }
    }

    public override function get():Variant {
        if (Std.is(_component.window, RadioButton)) {
            return cast(_component.window, RadioButton).value;
        } else if (Std.is(_component.window, Slider)) {
            return cast(_component.window, Slider).value;
        } else if (Std.is(_component.window, Gauge)) {
            return cast(_component.window, Gauge).value;
        }
        return null;
    }
}