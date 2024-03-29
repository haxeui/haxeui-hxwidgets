package haxe.ui.backend.hxwidgets.custom;

import haxe.ui.backend.hxwidgets.TreeViewIcons;
import haxe.ui.backend.hxwidgets.builders.TreeViewBuilder;
import haxe.ui.containers.TreeView;
import haxe.ui.core.Component;
import hx.widgets.DataViewItem;
import hx.widgets.DataViewTreeCtrl;
import haxe.ui.util.Variant;

class TreeViewNode extends haxe.ui.containers.TreeViewNode {
    public var treeView:TreeView = null;
    public var dataViewItem:DataViewItem = null;
    
    public function applyExpanded() {
        if (_expand != null) {
            set_expanded(_expand);
            _expand = null;
        }
    }

    private override function set_data(value:Dynamic):Dynamic {
        if (value == _data) {
            return value;
        }
        var r = super.set_data(value);
        updateNodeFromData();
        return r;
    }
    
    private function updateNodeFromData() {
        if (treeView == null || dataViewItem == null || treeView.window == null) {
            return;
        }
        
        var treeCtrl:DataViewTreeCtrl = cast(treeView.window, DataViewTreeCtrl);
        var text:String = _data.text;
        var icon:String = _data.icon;
        if ((_data.icon is VariantType)) {
            icon = Variant.fromDynamic(_data.icon);
        }
        
        treeCtrl.setItemText(dataViewItem, text);
        if (icon != null) {
            treeCtrl.setItemIconIndex(dataViewItem, TreeViewIcons.get(treeView, icon));
        }
    }
    
    private var _expand:Null<Bool> = null;
    private override function get_expanded():Bool {
        if (treeView == null || dataViewItem == null || treeView.window == null) {
            return _expand;
        }
        
        var treeCtrl:DataViewTreeCtrl = cast(treeView.window, DataViewTreeCtrl);
        return treeCtrl.isExpanded(dataViewItem);
    }
    private override function set_expanded(value:Bool):Bool {
        if (treeView == null || dataViewItem == null || treeView.window == null) {
            _expand = value;
            return value;
        }
        
        var treeCtrl:DataViewTreeCtrl = cast(treeView.window, DataViewTreeCtrl);
        if (value) {
            treeCtrl.expand(dataViewItem);
        } else {
            treeCtrl.collapse(dataViewItem);
        }
        return value;
    }
    
    private override function getNodesInternal():Array<Component> {
        if (treeView == null || dataViewItem == null || treeView.window == null) {
            return [];
        }
        
        var nodes:Array<Component> = [];
        @:privateAccess var builder:TreeViewBuilder = cast(treeView._compositeBuilder, TreeViewBuilder);
        var internalNodes = builder.dataViewItemChildren(dataViewItem);
        for (node in internalNodes) {
            nodes.push(node);
        }
        return nodes;
    }
    
    private override function get_selected():Bool {
        if (treeView == null) {
            return false;
        }
        return treeView.selectedNode == this;
    }
    private override function set_selected(value:Bool):Bool {
        if (treeView == null) {
            return value;
        }
        
        treeView.selectedNode = this;
        return value;
    }
}