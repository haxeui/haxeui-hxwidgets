package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import hx.widgets.Choice;

class ChoiceSelectedLabel extends DataBehaviour {
    public override function get():Variant {
        if (_component.window == null) {
            return _value;
        }
        var choice:Choice = cast(_component.window, Choice);
        return choice.selectedString;
    }

    public override function set(value:Variant) {
        if (_component.window == null) {
            _value = value;
            return;
        }
        super.set(value);
    }

    public override function update() {
        super.update();
        set(_value);
    }

    public override function validateData() {
        super.validateData();
        var choice:Choice = cast(_component.window, Choice);
        choice.selectedString = _value;
    }
}