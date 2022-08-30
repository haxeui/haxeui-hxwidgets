package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.backend.hxwidgets.builders.TreeViewBuilder;
import haxe.ui.backend.hxwidgets.custom.TreeViewNode;
import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.containers.TreeView;
import haxe.ui.events.UIEvent;
import haxe.ui.util.Variant;
import hx.widgets.DataViewTreeCtrl;

class TreeViewSelectedNode extends DataBehaviour {
    public override function get():Variant {
        if (_component.isReady == false || _component.window == null) {
            return _value;
        }
        
        var treeview = cast(_component, TreeView);
        @:privateAccess var builder:TreeViewBuilder = cast(treeview._compositeBuilder, TreeViewBuilder);
        var treeCtrl:DataViewTreeCtrl = cast(treeview.window, DataViewTreeCtrl);
        var selectedDataViewItem = treeCtrl.selection;
        var selectedNode = builder.dataViewItemToNode(selectedDataViewItem);
        return selectedNode;
    }
    
    public override function validateData() {
        var treeview = cast(_component, TreeView);
        @:privateAccess var builder:TreeViewBuilder = cast(treeview._compositeBuilder, TreeViewBuilder);
        if (treeview.window != null) {
            var treeCtrl:DataViewTreeCtrl = cast(treeview.window, DataViewTreeCtrl);
            if (_value != null && _value.isNull == false) {
                var dataViewItem = cast(_value.toComponent(), TreeViewNode).dataViewItem;
                treeCtrl.selection = dataViewItem;
                treeCtrl.ensureVisible(dataViewItem);
            } else {
                if (treeCtrl.selection != null) {
                    treeCtrl.unselect(treeCtrl.selection);
                }
            }
            var event = new UIEvent(UIEvent.CHANGE);
            _component.dispatch(event);
        }
    }
}