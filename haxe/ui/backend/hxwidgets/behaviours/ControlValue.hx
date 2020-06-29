package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import hx.widgets.CheckBox;
import hx.widgets.Control;
import hx.widgets.Gauge;
import hx.widgets.RadioButton;
import hx.widgets.ScrollBar;
import hx.widgets.Slider;
import hx.widgets.SpinCtrl;
import hx.widgets.StaticBox;
import hx.widgets.TextCtrl;
import hx.widgets.ToggleButton;

@:keep
class ControlValue extends DataBehaviour {
    public override function validateData() {
        if (Std.is(_component.window, Gauge)) {
            cast(_component.window, Gauge).value = _value;
        } else if (Std.is(_component.window, Slider)) {
            cast(_component.window, Slider).value = _value;
        } else if (Std.is(_component.window, ScrollBar)) {
            var scroll:ScrollBar = cast(_component.window, ScrollBar);
            scroll.setScrollbar(_value, scroll.thumbSize, scroll.range, scroll.pageSize);
        } else if (Std.is(_component.window, CheckBox)) {
            cast(_component.window, CheckBox).value = _value;
        } else if (Std.is(_component.window, RadioButton)) {
            cast(_component.window, RadioButton).value = _value;
        } else if (Std.is(_component.window, ToggleButton)) {
            cast(_component.window, ToggleButton).value = _value;
        } else if (Std.is(_component.window, TextCtrl)) {
            cast(_component.window, TextCtrl).value = normalizeText(_value);
        } else if (Std.is(_component.window, SpinCtrl)) {
            cast(_component.window, SpinCtrl).value = _value;
        } else if (Std.is(_component.window, StaticBox)) {
            cast(_component.window, StaticBox).label = normalizeText(_value);
        }
    }

    public override function get():Variant {
        var v:Variant = null;
        if (Std.is(_component.window, Gauge)) {
            v = cast(_component.window, Gauge).value;
        } else if (Std.is(_component.window, Slider)) {
            v = cast(_component.window, Slider).value;
        } else if (Std.is(_component.window, CheckBox)) {
            v = cast(_component.window, CheckBox).value;
        } else if (Std.is(_component.window, RadioButton)) {
            v = cast(_component.window, RadioButton).value;
        } else if (Std.is(_component.window, ToggleButton)) {
            v = cast(_component.window, ToggleButton).value;
        } else if (Std.is(_component.window, TextCtrl)) {
            v = cast(_component.window, TextCtrl).value;
        } else if (Std.is(_component.window, SpinCtrl)) {
            v = cast(_component.window, SpinCtrl).value;
        } else if (Std.is(_component.window, StaticBox)) {
            v = cast(_component.window, StaticBox).label;
        }
        return v;
    }
    
    private inline function normalizeText(s:String) {
        s = StringTools.replace(s, "\\n", "\r\n");
        return s;
    }
}