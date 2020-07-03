package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.data.DataSource;
import haxe.ui.util.Variant;
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
            if (Type.typeof(item) == TObject && item.text != null) {
                view.addItem(new ListItem(item.text, ListViewIcons.get(cast _component, item.icon)));
            } else {
                view.addItem(new ListItem(Std.string(item)));
            }
        }
    }
    
    public override function set(value:Variant) {
        super.set(value);
        if (value != null && value.isNull == false) {
            var ds:DataSource<Dynamic> = value;
            ds.onChange = function() {
                validateData();
            }
        }
    }
    
    public override function get():Variant {
        if (_value == null || _value.isNull) {
            _value = new ArrayDataSource<Dynamic>();
            set(_value);
        }
        return _value;
    }
}