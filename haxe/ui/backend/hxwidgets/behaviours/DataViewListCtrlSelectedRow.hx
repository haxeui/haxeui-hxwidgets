package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.DataViewListCtrl;

class DataViewListCtrlSelectedRow extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        if (_component.window == null) {
            return;
        }

        if (value.isNull) {
            return;
        }
        
        var dataList:DataViewListCtrl = cast(_component.window, DataViewListCtrl);
        dataList.selectedRow = value;
    }
    
    public override function get():Variant {
        if (_component.window == null) {
            return false;
        }
        
        var dataList:DataViewListCtrl = cast(_component.window, DataViewListCtrl);
        return dataList.selectedRow;
    }
}