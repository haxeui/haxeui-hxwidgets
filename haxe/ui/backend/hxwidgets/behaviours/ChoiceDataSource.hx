package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.data.DataSource;
import haxe.ui.util.Variant;
import hx.widgets.Choice;

class ChoiceDataSource extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        if (_component.window == null) {
            return;
        }

        if (value.isNull) {
            return;
        }
        
        var ds:DataSource<Dynamic> = value;
        var choice:Choice = cast(_component.window, Choice);
        choice.clear();
        
        for (n in 0...ds.size) {
            var item = ds.get(n);
            if (item.value != null) {
                choice.append(item.value);
            }
        }
    }
}