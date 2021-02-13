package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.backend.hxwidgets.TableViewIcons;
import haxe.ui.backend.hxwidgets.builders.TableViewBuilder;
import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.data.DataSource;
import haxe.ui.util.Variant;
import hx.widgets.Bitmap;
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
        var tableSize:Int = dataList.itemCount;
        for (n in 0...ds.size) {
            var item = ds.get(n);
            if (n > tableSize - 1) {
                var values:Array<Any> = [];
                var i = 0;
                for (col in builder.columns) {
                    var r = builder.getRendererInfo(i);
                    var v:Dynamic = Reflect.field(item, col.id);
                    switch (r.type) {
                        case "checkbox":
                            v = (v == "true");
                        case "progress":
                            v = Std.parseInt(v);
                        case "image":
                            v = TableViewIcons.get(v);
                    }
                    values.push(v);
                    i++;
                }
                dataList.appendItem(values);
            } else {
                var columnCount = dataList.columnCount;
                for (colIndex in 0...columnCount) {
                    var r = builder.getRendererInfo(colIndex);
                    var columnInfo = builder.columns[colIndex];
                    var datasourceValue:Dynamic = Reflect.field(item, columnInfo.id);
                    var currentValue = dataList.getValue(n, colIndex);
                    var changed = false;
                    switch (r.type) {
                        case "image":
                            changed = TableViewIcons.findAndCompare(datasourceValue, cast(currentValue, Bitmap));
                        case _:
                            changed = (currentValue != datasourceValue);
                    }
                    if (changed == true) {
                        switch (r.type) {
                            case "checkbox":
                                dataList.setValue(n, colIndex, (datasourceValue == true));
                            case "progress":
                                dataList.setValue(n, colIndex, Std.parseInt(datasourceValue));
                            case "image":
                                dataList.setValue(n, colIndex, TableViewIcons.get(datasourceValue));
                            case _:    
                                dataList.setValue(n, colIndex, datasourceValue);
                        }
                    }
                }
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