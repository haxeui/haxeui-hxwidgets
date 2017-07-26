package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.backend.hxwidgets.custom.SimpleListView;
import haxe.ui.data.DataSource;
import haxe.ui.util.Variant;
import hx.widgets.ListItem;
import hx.widgets.ListView;

@:access(haxe.ui.backend.ComponentBase)
class ListViewDataSource extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        if (_component.window == null) {
            return;
        }

        if (value.isNull) {
            return;
        }

        var ds:DataSource<Dynamic> = value;
        var view:ListView = cast(_component.window, ListView);

        for (n in 0...ds.size) {
            var item = ds.get(n);
            if (item.value != null) {
                view.addItem(new ListItem(item.value, ListViewIcons.get(cast _component, item.icon)));
            }
        }

        _component.set("dataSource", ds);
    }
}