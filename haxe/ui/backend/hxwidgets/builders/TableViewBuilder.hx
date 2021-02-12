package haxe.ui.backend.hxwidgets.builders;

import haxe.ui.components.Button;
import haxe.ui.containers.Header;
import haxe.ui.containers.TableView;
import haxe.ui.core.Component;
import haxe.ui.core.CompositeBuilder;
import hx.widgets.DataViewListCtrl;
import haxe.ui.core.Platform;

typedef ColumnInfo = {
    id:String,
    text:String,
    ?width:Null<Float>,
    ?percentWidth:Null<Float>
}

@:access(haxe.ui.backend.ComponentImpl)
class TableViewBuilder extends CompositeBuilder {
    private var _table:TableView;
    private var _header:Header;
    public var headersCreated:Bool = false;
    public var columns:Array<ColumnInfo> = [];
    
    public function new(table:TableView) {
        super(table);
        _table = table;
    }
    
    public override function create() {
        createColumns();
    }
    
    public override function onReady() {
        createColumns();
    }
    
    public override function addComponent(child:Component):Component {
        if (Std.is(child, Header)) {
            _header = cast(child, Header);
            _header.ready();
            createColumns();
            return child;
        }
        return child;
    }
    
    private function createColumns() {
        if (_header != null && _component.window != null && headersCreated == false) {
            var dataList:DataViewListCtrl = cast(_component.window, DataViewListCtrl);
            for (col in _header.childComponents) {
                var button:Button = cast(col, Button);
                dataList.appendTextColumn(col.text);
                columns.push({
                    id: col.id,
                    text: col.text,
                    width: button.width,
                    percentWidth: button.percentWidth
                });
                
            }
            
            // may be ill concieved... might mean you cant add columns later, for now its fine
            _header.removeAllComponents();
            _header.window.scheduleForDestruction();
            _header = null;
            
            headersCreated = true;
            resizeColumns();
            //_table.invalidateComponentData();
            _table.dataSource = _table.dataSource;
            
            
        }
    }
    
    private function resizeColumns() {
        var dataList:DataViewListCtrl = cast(_component.window, DataViewListCtrl);
        var size = dataList.clientSize;
        var i = 0;
        var ucx:Float = size.width;
        for (c in columns) {
            if (c.percentWidth == null) {
                var dc = dataList.getColumn(i);
                var cx = c.width;
                dc.width = Std.int(cx);
                ucx -= cx;
            }
            i++;
        }
        
        ucx -= Platform.vscrollWidth;
        
        var i = 0;
        for (c in columns) {
            if (c.percentWidth != null) {
                var dc = dataList.getColumn(i);
                var cx = (ucx * c.percentWidth) / 100;
                dc.width = Std.int(cx);
            }
            i++; 
        }
    }
    
    
}