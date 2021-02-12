package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.backend.hxwidgets.builders.TableViewBuilder;
import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.data.DataSource;
import haxe.ui.util.Variant;
import hx.widgets.DataViewListCtrl;

@:access(haxe.ui.core.Component)
class TableViewDataSource extends DataBehaviour {
    public override function validateData() {
        if (_component.window == null) {
            return;
        }
        
        var builder = cast(_component._compositeBuilder, TableViewBuilder);
        if (builder.headersCreated == false) {
            return;
        }
        var dataList:DataViewListCtrl = cast(_component.window, DataViewListCtrl);
        
        var ds:DataSource<Dynamic> = _value;
        for (n in 0...ds.size) {
            var item = ds.get(n);
            var values:Array<Any> = [];
            for (col in builder.columns) {
                var v = Reflect.field(item, col.id);
                values.push(v);
            }
            dataList.appendItem(values);
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