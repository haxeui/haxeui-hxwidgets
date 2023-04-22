package haxe.ui.backend.hxwidgets.behaviours;
import haxe.ui.backend.hxwidgets.builders.TreeViewBuilder;
import haxe.ui.backend.hxwidgets.custom.TreeViewNode;
import haxe.ui.behaviours.Behaviour;
import haxe.ui.containers.TreeView;
import haxe.ui.util.Variant;
import hx.widgets.DataViewItem;
import hx.widgets.DataViewTreeCtrl;

class TreeViewGetNodesInternal extends Behaviour {
    public override function call(param:Any = null):Variant {
        var treeview:TreeView = null;
        var dataViewItem:DataViewItem = null;
        if ((_component is TreeView)) {
            treeview = cast(_component, TreeView);
        } else if ((_component is TreeViewNode)) {
            treeview = cast(_component, TreeViewNode).treeView;
            dataViewItem = cast(_component, TreeViewNode).dataViewItem;
        }
        
        if (treeview == null) {
            return null;
        }

        @:privateAccess var builder:TreeViewBuilder = cast(treeview._compositeBuilder, TreeViewBuilder);
        var nodes:Array<TreeViewNode> = builder.dataViewItemChildren(dataViewItem);
        return nodes;
    }
}