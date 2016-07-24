package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.CheckBox;
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
        
        /*
        if (_component.window == null) {
            return;
        }

        if (Std.is(_component, haxe.ui.components.HProgress) || Std.is(_component, haxe.ui.components.VProgress)) {
            var gauge:Gauge = cast _component.window;
            gauge.value = value;
        } else if (Std.is(_component, haxe.ui.components.HSlider) || Std.is(_component, haxe.ui.components.VSlider)) {
            var slider:Slider = cast _component.window;
            slider.value = value;
        } else if (Std.is(_component, haxe.ui.components.HScroll) || Std.is(_component, haxe.ui.components.VScroll)) {
            var scroll:ScrollBar = cast _component.window;
            scroll.setScrollbar(value, scroll.getThumbSize(), scroll.getRange(), scroll.getPageSize());
        } else if (Std.is(_component, haxe.ui.components.CheckBox)) {
            var checkbox:CheckBox = cast _component.window;
            checkbox.value = value;
        } else if (Std.is(_component, haxe.ui.components.OptionBox)) {
            var checkbox:RadioButton = cast _component.window;
            checkbox.value = value;
        }
        */
    }
    
    public override function get():Variant {
        /*
        if (_component.window == null) {
            return null;
        }
        */
        return null;
    }
}