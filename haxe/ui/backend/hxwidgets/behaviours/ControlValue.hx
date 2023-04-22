package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.components.Button.ButtonGroups;
import haxe.ui.components.TextArea;
import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import hx.widgets.CheckBox;
import hx.widgets.Control;
import hx.widgets.Gauge;
import hx.widgets.RadioButton;
import hx.widgets.ScrollBar;
import hx.widgets.Slider;
import hx.widgets.SpinCtrl;
import hx.widgets.TextCtrl;
import hx.widgets.ToggleButton;

@:keep
class ControlValue extends DataBehaviour {
    public override function validateData() {
        if ((_component.window is Gauge)) {
            cast(_component.window, Gauge).value = _value;
        } else if ((_component.window is Slider)) {
            cast(_component.window, Slider).value = _value;
        } else if ((_component.window is ScrollBar)) {
            var scroll:ScrollBar = cast(_component.window, ScrollBar);
            scroll.setScrollbar(_value, scroll.thumbSize, scroll.range, scroll.pageSize);
        } else if ((_component.window is CheckBox)) {
            cast(_component.window, CheckBox).value = _value;
        } else if ((_component.window is RadioButton)) {
            cast(_component.window, RadioButton).value = _value;
        } else if ((_component.window is ToggleButton)) {
            ButtonGroups.instance.setSelection(cast _component, _value);
            cast(_component.window, ToggleButton).value = _value;
        } else if ((_component.window is TextCtrl)) {
            cast(_component.window, TextCtrl).value = normalizeText(_value);
            if ((_component is TextArea)) {
                if (cast(_component, TextArea).autoScrollToBottom){
                    cast(_component.window, TextCtrl).insertionPoint = -1;
                }
            }
        } else if ((_component.window is SpinCtrl)) {
            cast(_component.window, SpinCtrl).value = _value;
        }
    }

    public override function get():Variant {
        var v:Variant = null;
        if ((_component.window is Gauge)) {
            v = cast(_component.window, Gauge).value;
        } else if ((_component.window is Slider)) {
            v = cast(_component.window, Slider).value;
        } else if ((_component.window is CheckBox)) {
            v = cast(_component.window, CheckBox).value;
        } else if ((_component.window is RadioButton)) {
            v = cast(_component.window, RadioButton).value;
        } else if ((_component.window is ToggleButton)) {
            v = cast(_component.window, ToggleButton).value;
        } else if ((_component.window is TextCtrl)) {
            v = cast(_component.window, TextCtrl).value;
        } else if ((_component.window is SpinCtrl)) {
            v = cast(_component.window, SpinCtrl).value;
        }
        return v;
    }
    
    private inline function normalizeText(s:String) {
        s = StringTools.replace(s, "\\n", "\r\n");
        return s;
    }
}