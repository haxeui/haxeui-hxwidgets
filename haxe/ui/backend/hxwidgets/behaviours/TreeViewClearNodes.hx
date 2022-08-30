package haxe.ui.backend.hxwidgets.behaviours;
import haxe.ui.backend.hxwidgets.builders.TreeViewBuilder;
import haxe.ui.backend.hxwidgets.custom.TreeViewNode;
import haxe.ui.behaviours.Behaviour;
import haxe.ui.containers.TreeView;
import haxe.ui.util.Variant;
import hx.widgets.DataViewTreeCtrl;

class TreeViewClearNodes extends Behaviour {
    public override function call(param:Any = null):Variant {
        var treeview:TreeView = null;
        if ((_component is TreeView)) {
            treeview = cast(_component, TreeView);
        } else if ((_component is TreeViewNode)) {
            treeview = cast(_component, TreeViewNode).treeView;
        }
        
        if (treeview == null) {
            return null;
        }

        var node:TreeViewNode = cast(_component, TreeViewNode);
        var treeCtrl:DataViewTreeCtrl = cast(treeview.window, DataViewTreeCtrl);
        @:privateAccess var builder:TreeViewBuilder = cast(treeview._compositeBuilder, TreeViewBuilder);
        if (treeCtrl != null) {
            builder.clearNodes(node);
        } else {
            builder.nodesToCreate.remove(node);
        }
        return null;
    }
}