package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
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
    
    public override function get():Variant {
        var choice:Choice = cast(_component.window, Choice);
        if (choice == null) {
            return -1;
        }
        return choice.selection;
    }
}
