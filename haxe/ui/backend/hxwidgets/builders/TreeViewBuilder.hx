package haxe.ui.backend.hxwidgets.builders;

import haxe.ui.backend.hxwidgets.custom.TreeViewNode;
import haxe.ui.containers.TreeView;
import haxe.ui.core.CompositeBuilder;
import hx.widgets.DataViewItem;
import hx.widgets.DataViewTreeCtrl;
import hx.widgets.EventType;

class TreeViewBuilder extends CompositeBuilder {
    private var _treeview:TreeView = null;
    public var nodesToCreate:Array<TreeViewNode> = [];
    
    public function new(treeview:TreeView) {
        super(treeview);
        _treeview = treeview;
    }
    
    public override function onInitialize() {
        super.onInitialize();
        var treeCtrl:DataViewTreeCtrl = cast(_component.window, DataViewTreeCtrl);
        treeCtrl.indent = 16;
        for (node in nodesToCreate) {
            createNode(node);
        }
        nodesToCreate = null;
    }
    
    public function dataViewItemToNode(dataViewItem:DataViewItem):TreeViewNode {
        if (dataViewItem == null) {
            return null;
        }
        return _dataViewItemToNodeMap.get(dataViewItem.id);
    }
    
    public function dataViewItemChildren(dataViewItem:DataViewItem):Array<TreeViewNode> {
        var children = [];
        if (dataViewItem == null) { // seems no easy way to get root nodes in wx api
            for (k in _dataViewItemToNodeMap.keys()) {
                var v = _dataViewItemToNodeMap.get(k);
                if (v.parentNode == null) {
                    children.push(v);
                }
            }
        } else {
            var treeCtrl:DataViewTreeCtrl = cast(_component.window, DataViewTreeCtrl);
            var childCount = treeCtrl.getChildCount(dataViewItem);
            for (n in 0...childCount) {
                var childDataItem = treeCtrl.getNthChild(dataViewItem, n);
                if (_dataViewItemToNodeMap.exists(childDataItem.id)) {
                    children.push(_dataViewItemToNodeMap.get(childDataItem.id));
                }
            }
        }
        return children;
    }
    
    private var _dataViewItemToNodeMap:Map<Int, TreeViewNode> = new Map<Int, TreeViewNode>();
    public function createNode(node:TreeViewNode) {
        var treeCtrl:DataViewTreeCtrl = cast(_component.window, DataViewTreeCtrl);
        var text = node.data.text;
        var icon = node.data.icon;
        if (node.parentNode == null) {
            node.dataViewItem = treeCtrl.appendItem(null, text, TreeViewIcons.get(_treeview, icon));
            _dataViewItemToNodeMap.set(node.dataViewItem.id, node);
        } else {
            var parentNode = cast(node.parentNode, TreeViewNode); // its a different _type_ of TreeViewNode
            if (parentNode.dataViewItem != null && !treeCtrl.isContainer(parentNode.dataViewItem)) { // we want to change the type from an item to a container since it has childrel (wx widgets is fun!)
                var selectedNode = cast(_treeview.selectedNode, TreeViewNode); // its a different _type_ of TreeViewNode
                deleteDataViewItem(parentNode.dataViewItem, false);
                if (parentNode.parentNode == null) {
                    parentNode.dataViewItem = treeCtrl.appendContainer(null, parentNode.data.text, TreeViewIcons.get(_treeview, parentNode.data.icon));
                    _dataViewItemToNodeMap.set(parentNode.dataViewItem.id, parentNode);
                } else {
                    parentNode.dataViewItem = treeCtrl.appendContainer(cast(parentNode.parentNode, TreeViewNode).dataViewItem, parentNode.data.text, TreeViewIcons.get(_treeview, parentNode.data.icon));
                    _dataViewItemToNodeMap.set(parentNode.dataViewItem.id, parentNode);
                }
                if (selectedNode != null) {
                    treeCtrl.pauseEvent(EventType.DATAVIEW_SELECTION_CHANGED);
                    treeCtrl.selection = selectedNode.dataViewItem;
                    treeCtrl.unpauseEvent(EventType.DATAVIEW_SELECTION_CHANGED);
                }
            }
            node.dataViewItem = treeCtrl.appendItem(parentNode.dataViewItem, text, TreeViewIcons.get(_treeview, icon));
            _dataViewItemToNodeMap.set(node.dataViewItem.id, node);
        }
    }

    public function removeNode(node:TreeViewNode) {
        deleteDataViewItem(node.dataViewItem, true);
        node.treeView = null;
        node.dataViewItem = null;
    }
    
    public function clearNodes(node:TreeViewNode) {
        if (node == null) {
            return;
        }
        var treeCtrl:DataViewTreeCtrl = cast(_component.window, DataViewTreeCtrl);
        while (treeCtrl.getChildCount(node.dataViewItem) > 0) {
            deleteDataViewItem(treeCtrl.getNthChild(node.dataViewItem, 0), true);
        }
    }
    
    private function deleteDataViewItem(dataViewItem:DataViewItem, clearObjects:Bool) {
        var treeCtrl:DataViewTreeCtrl = cast(_component.window, DataViewTreeCtrl);
        while (treeCtrl.getChildCount(dataViewItem) > 0) {
            deleteDataViewItem(treeCtrl.getNthChild(dataViewItem, 0), clearObjects);
        }
        treeCtrl.deleteItem(dataViewItem);
        if (_dataViewItemToNodeMap.exists(dataViewItem.id)) {
            var node = _dataViewItemToNodeMap.get(dataViewItem.id);
            _dataViewItemToNodeMap.remove(dataViewItem.id);
            if (clearObjects) {
                node.treeView = null;
                node.dataViewItem = null;
            }
        }
    }
}