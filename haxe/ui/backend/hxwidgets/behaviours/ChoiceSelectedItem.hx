package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.data.DataSource;
import hx.widgets.Choice;

@:access(haxe.ui.backend.ComponentBase)
class ChoiceSelectedItem extends HxWidgetsBehaviour {
    public override function getDynamic():Dynamic {
        var data:Dynamic = null;
        if (_component.has("dataSource") == true) {
            var choice:Choice = cast(_component.window, Choice);
            var ds:DataSource<Dynamic> = cast _component.get("dataSource");
            data = ds.get(choice.selection);
        }
        return data;
    }
}