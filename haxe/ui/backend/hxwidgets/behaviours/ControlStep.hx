package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import haxe.ui.util.MathUtil;
import hx.widgets.SpinCtrlDouble;

@:keep
class ControlStep extends DataBehaviour {
    public override function validateData() {
        if (_component.window == null) {
            return;
        }

        var spin:SpinCtrlDouble = cast(_component.window, SpinCtrlDouble);
        spin.increment = _value;
        spin.digits = MathUtil.precision(_value);
    }
}
