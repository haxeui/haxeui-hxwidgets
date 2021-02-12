package haxe.ui.backend.hxwidgets.builders;

import haxe.ui.components.Button;
import haxe.ui.components.CheckBox;
import haxe.ui.components.Image;
import haxe.ui.components.Progress;
import haxe.ui.containers.Header;
import haxe.ui.containers.TableView;
import haxe.ui.core.Component;
import haxe.ui.core.CompositeBuilder;
import haxe.ui.core.ItemRenderer;
import hx.widgets.DataViewBitmapRenderer;
import hx.widgets.DataViewColumn;
import hx.widgets.DataViewListCtrl;
import haxe.ui.core.Platform;
import hx.widgets.DataViewProgressRenderer;
import hx.widgets.DataViewRenderer;
import hx.widgets.DataViewTextRenderer;
import hx.widgets.DataViewToggleRenderer;

typedef ColumnInfo = {
    id:String,
    text:String,
    ?width:Null<Float>,
    ?percentWidth:Null<Float>
}

typedef RendererInfo = {
    type:String
}

@:access(haxe.ui.backend.ComponentImpl)
class TableViewBuilder extends CompositeBuilder {
    private var _table:TableView;
    private var _header:Header;
    public var headersCreated:Bool = false;
    public var columns:Array<ColumnInfo> = [];
    public var renderers:Array<RendererInfo> = [];
    
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
        } else if (Std.is(child, ItemRenderer)) {
            if (child.findComponent(CheckBox) != null) {
                renderers.push({ type: "checkbox" });
            } else if (child.findComponent(Progress) != null) {
                renderers.push({ type: "progress" });
            } else if (child.findComponent(Image) != null) {
                renderers.push({ type: "image" });
            } else {
                renderers.push({ type: "label" });
            }
        }
        return child;
    }
    
    private function createColumns() {
        if (_header != null && _component.window != null && headersCreated == false) {
            var dataList:DataViewListCtrl = cast(_component.window, DataViewListCtrl);
            var i = 0;
            for (col in _header.childComponents) {
                var renderer = getRendererInfo(i);
                var button:Button = cast(col, Button);
                var r:DataViewRenderer = null;
                switch (renderer.type) {
                    case "checkbox":
                        r = new DataViewToggleRenderer();
                    case "progress":
                        r = new DataViewProgressRenderer();
                    case "image":
                        r = new DataViewBitmapRenderer();
                    case _:    
                        r = new DataViewTextRenderer();
                }
                
                var c = new DataViewColumn(col.text, r, i);
                dataList.appendColumn(c);
                
                columns.push({
                    id: col.id,
                    text: col.text,
                    width: button.width,
                    percentWidth: button.percentWidth
                });
                i++;
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
    
    public function getRendererInfo(index:Int) {
        if (index > renderers.length - 1) {
            return {
                type: "label"
            };
        }
        
        return renderers[index];
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