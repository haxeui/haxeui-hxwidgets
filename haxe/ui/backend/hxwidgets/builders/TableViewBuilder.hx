package haxe.ui.backend.hxwidgets.builders;

import hx.widgets.Alignment;
import haxe.ui.components.Button;
import haxe.ui.components.CheckBox;
import haxe.ui.components.Image;
import haxe.ui.components.NumberStepper;
import haxe.ui.components.Progress;
import haxe.ui.components.Switch;
import haxe.ui.containers.Header;
import haxe.ui.containers.TableView;
import haxe.ui.core.Component;
import haxe.ui.core.CompositeBuilder;
import haxe.ui.core.ItemRenderer;
import haxe.ui.events.ItemEvent;
import haxe.ui.events.UIEvent;
import hx.widgets.DataViewBitmapRenderer;
import hx.widgets.DataViewColumn;
import hx.widgets.DataViewEvent;
import hx.widgets.DataViewListCtrl;
import haxe.ui.core.Platform;
import hx.widgets.DataViewProgressRenderer;
import hx.widgets.DataViewRenderer;
import hx.widgets.DataViewSpinRenderer;
import hx.widgets.DataViewTextRenderer;
import hx.widgets.DataViewToggleRenderer;
import hx.widgets.Event;
import hx.widgets.EventType;

typedef ColumnInfo = {
    id:String,
    text:String,
    ?width:Null<Float>,
    ?percentWidth:Null<Float>
}

typedef RendererInfo = {
    type:String,
    component:Component
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
        if ((child is Header)) {
            _header = cast(child, Header);
            _header.ready();
            createColumns();
            return child;
        } else if ((child is ItemRenderer)) {
            if (child.findComponent(CheckBox) != null) {
                renderers.push({ type: "checkbox", component: child.findComponent(CheckBox) });
            } else if (child.findComponent(Switch) != null) {
                renderers.push({ type: "checkbox", component: child.findComponent(Switch) });
            } else if (child.findComponent(Progress) != null) {
                renderers.push({ type: "progress", component: child.findComponent(Progress) });
            } else if (child.findComponent(Image) != null) {
                renderers.push({ type: "image", component: child.findComponent(Image) });
            } else if (child.findComponent(NumberStepper) != null) {
                renderers.push({ type: "number", component: child.findComponent(NumberStepper) });
            } else {
                renderers.push({ type: "label", component: child });
            }
        }
        return child;
    }
    
    private function createColumns() {
        if (_header != null && _component.window != null && headersCreated == false) {
            var dataList:DataViewListCtrl = cast(_component.window, DataViewListCtrl);
            var i = 0;
            for (col in _header.childComponents) {
                var alignment = Alignment.LEFT;
                if (col.style != null && col.style.textAlign != null) {
                    switch (col.style.textAlign) {
                        case "center":
                            alignment = Alignment.CENTER;
                        case "right":
                            alignment = Alignment.RIGHT;
                        case _:    
                            alignment = Alignment.LEFT;
                    }
                }
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
                    case "number":
                        r = new DataViewSpinRenderer();
                    case _:    
                        r = new DataViewTextRenderer();
                }
                r.alignment = alignment | Alignment.CENTER_VERTICAL;
                var columnText = col.text;
                if (columnText == null) {
                    columnText = "";
                }
                var c = new DataViewColumn(columnText, r, i);
                c.alignment = alignment;
                dataList.appendColumn(c);
                
                columns.push({
                    id: col.id,
                    text: col.text,
                    width: button.width,
                    percentWidth: button.percentWidth
                });
                i++;
            }
            
            headersCreated = true;
            //_table.invalidateComponentData();
            _table.dataSource = _table.dataSource;
            _table.registerEvent(UIEvent.RESIZE, onTableResized);
            
            _table.window.bind(EventType.DATAVIEW_ITEM_VALUE_CHANGED, onItemChanged);
        }

        resizeColumns();
    }
    
    private function onItemChanged(e:Event) {
        var dve:DataViewEvent = e.convertTo(DataViewEvent);
        var dataList:DataViewListCtrl = cast(_component.window, DataViewListCtrl);
        var column = dve.column;
        var row =  dataList.itemToRow(dve.item);
        var columnInfo = columns[column];
        var renderer = getRendererInfo(column);
        var newValue = dataList.getValue(row, column);
        
        var realValue:Dynamic = null;
        var sendEvent = false;
        switch (renderer.type) {
            case "checkbox":
                realValue = Std.string(newValue) == "true";
                sendEvent = true;
            case "progress":
                realValue = Std.parseInt(newValue);
            case "image":
                realValue = Std.string(newValue);
            case "number":
                realValue = Std.parseInt(newValue);
                sendEvent = true;
            case _:    
                realValue = Std.string(newValue);
        }
        
        if (realValue != null) {
            var item = _table.dataSource.get(row);
            Reflect.setField(item, columnInfo.id, realValue);
            
            if (sendEvent == true) {
                var e = new ItemEvent(ItemEvent.COMPONENT_EVENT);
                e.bubble = true;
                if (renderer.component != null) {
                    e.source = renderer.component;
                }
                e.sourceEvent = new UIEvent(UIEvent.CHANGE);
                e.itemIndex = row;
                e.data = item;
                _table.dispatch(e);
            }
        }
    }
    
    private function onTableResized(_) {
        resizeColumns();
    }
    
    public function getRendererInfo(index:Int):RendererInfo {
        if (index > renderers.length - 1) {
            return {
                type: "label",
                component: null
            };
        }
        
        return renderers[index];
    }
    
    private function resizeColumns() {
        if (_component.window == null) {
            return;
        }
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
        dataList.refresh();
    }
    
    
}