package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import hx.widgets.Choice;

class ChoiceSelectedLabel extends DataBehaviour {
    public override function get():Variant {
        var choice:Choice = cast(_component.window, Choice);
        return choice.selectedString;
    }
}