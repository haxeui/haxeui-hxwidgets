package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.core.DataBehaviour;
import hx.widgets.Choice;

class ChoiceSelectedIndex extends DataBehaviour {
    public override function validateData() {
        var choice:Choice = cast(_component.window, Choice);
        if (_value != -1) {
            choice.selection = _value;
        } else {
            choice.selection = -1;
        }
    }
}
