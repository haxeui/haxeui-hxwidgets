package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import hx.widgets.MenuItem;

class MenuDisable extends DataBehaviour {
    public override function validateData() {
        cast(_component.object, MenuItem).enable = !_value;
    }
}