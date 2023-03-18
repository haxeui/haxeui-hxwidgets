package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import hx.widgets.Choice;

@:access(haxe.ui.core.Component)
class ChoiceSelectedIndex extends DataBehaviour {
    public override function validateData() {
        var choice:Choice = cast(_component.window, Choice);
        if (_value != -1) {
            choice.selection = _value;
            _component.set("hasSelection", true);
        } else {
            choice.selection = -1;
            _component.set("hasSelection", false);
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
