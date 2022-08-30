package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.Toolkit;
import haxe.ui.backend.hxwidgets.builders.TreeViewBuilder;
import haxe.ui.backend.hxwidgets.custom.TreeViewNode;
import haxe.ui.behaviours.Behaviour;
import haxe.ui.containers.TreeView;
import haxe.ui.util.Variant;
import hx.widgets.DataViewTreeCtrl;

class TreeViewAddNode extends Behaviour {
    public override function call(param:Any = null):Variant {
        var treeview:TreeView = null;
        var isRoot:Bool = true;
        if ((_component is TreeView)) {
            treeview = cast(_component, TreeView);
        } else if ((_component is TreeViewNode)) {
            treeview = cast(_component, TreeViewNode).treeView;
            isRoot = false;
        }
        
        var node = new TreeViewNode();
        node.data = param;
        if (!isRoot) {
            node.parentNode = cast(_component, TreeViewNode);
        }
        var treeCtrl:DataViewTreeCtrl = cast(treeview.window, DataViewTreeCtrl);
        node.treeView = treeview;
        @:privateAccess var builder:TreeViewBuilder = cast(treeview._compositeBuilder, TreeViewBuilder);
        
        if (treeCtrl != null) {
            builder.createNode(node);
        } else {
            builder.nodesToCreate.push(node);
        }
        
        return node;
    }
}