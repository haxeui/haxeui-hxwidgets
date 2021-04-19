package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import hx.widgets.MenuItem;

class MenuLabel extends DataBehaviour {
    public override function validateData() {
        var item = cast(_component, haxe.ui.containers.menus.MenuItem);
        var label:String = _value;
        if (item.shortcutText != null) {
            label += "\t" + item.shortcutText;
        }
        cast(_component.object, MenuItem).label = label;
    }
}