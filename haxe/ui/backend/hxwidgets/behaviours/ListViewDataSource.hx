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
        
        if (_value.isNull) {
            view.deleteAllItems();
            return;
        }

        var ds:DataSource<Dynamic> = _value;
        var info:ListItem = new ListItem();
        var listSize:Int = view.itemCount;
        for (n in 0...ds.size) {
            var item:Dynamic = ds.get(n);

            if (n > listSize - 1) {
                view.addItem(createListItem(item));
            } else {
                info.id = n;
                var b = view.getItem(info);
                if (b == true) {
                    var image = 0;
                    var text = "";
                    if (Type.typeof(item) == TObject && item.text != null) {
                        text = item.text;
                        image = ListViewIcons.get(cast _component, item.icon);
                        if (image == -1) {
                            image = 0;
                        }
                    } else {
                        text = Std.string(item);
                    }
                    
                    if (info.text != text || info.image != image) {
                        info.text = text;
                        info.image = image;
                        view.setItem(info, false);
                    }
                }
            }
        }
        info.destroy();
    }
    
    private function createListItem(item:Dynamic) {
        if (Type.typeof(item) == TObject && item.text != null) {
            return new ListItem(item.text, ListViewIcons.get(cast _component, item.icon));
        }
        return new ListItem(Std.string(item));
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