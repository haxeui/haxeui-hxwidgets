package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import hx.widgets.MenuItem;
import haxe.ui.containers.menus.MenuCheckBox;
import haxe.ui.containers.menus.MenuOptionBox;

class MenuItemSelected extends DataBehaviour {
    public override function validateData() {
        var menuItem:MenuItem = cast _component.object; // unsafe cast (on purpose)
        if ((_component is MenuCheckBox)) {
            menuItem.check(cast(_component, MenuCheckBox).selected);
        } else if ((_component is MenuOptionBox)) {
            menuItem.check(cast(_component, MenuOptionBox).selected);
        }
    }
}