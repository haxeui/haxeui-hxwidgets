package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.data.DataSource;
import hx.widgets.ListItem;
import hx.widgets.ListView;

@:access(haxe.ui.backend.ComponentImpl)
class ListViewDataSource extends DataBehaviour {
    public override function validateData() {
        if (_component.window == null) {
            return;
        }

        var view:ListView = cast(_component.window, ListView);
        view.deleteAllItems();
        
        if (_value.isNull) {
            return;
        }

        var ds:DataSource<Dynamic> = _value;
        for (n in 0...ds.size) {
            var item = ds.get(n);
            if (item.value != null) {
                view.addItem(new ListItem(item.value, ListViewIcons.get(cast _component, item.icon)));
            }
        }
    }
}