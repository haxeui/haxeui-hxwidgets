package haxe.ui.backend.hxwidgets.builders;

import haxe.ui.events.MouseEvent;
import hx.widgets.EventType;
import hx.widgets.NotifyEvent;
import hx.widgets.EventType;
import hx.widgets.Event;
import haxe.ui.backend.hxwidgets.custom.TreeViewNode;
import haxe.ui.containers.TreeView;
import haxe.ui.core.CompositeBuilder;
import hx.widgets.DataViewItem;
import hx.widgets.DataViewTreeCtrl;
import hx.widgets.EventType;
import haxe.ui.backend.hxwidgets.Platform;

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
        if (Platform.isWindows) {
            treeCtrl.indent = 16;
        }
        treeCtrl.bind(EventType.DATAVIEW_ITEM_START_EDITING, onItemStartEdit);
        for (node in nodesToCreate) {
            createNode(node);
        }
        nodesToCreate = null;

        _component.window.bind(EventType.DATAVIEW_ITEM_CONTEXT_MENU, onContextMenu);
    }
    
    private function onContextMenu(_) {
        // we'll dispatch all right mouse events for good measure
        _treeview.dispatch(new MouseEvent(MouseEvent.RIGHT_MOUSE_DOWN));
        _treeview.dispatch(new MouseEvent(MouseEvent.RIGHT_CLICK));
        _treeview.dispatch(new MouseEvent(MouseEvent.RIGHT_MOUSE_UP));
    }

    private function onItemStartEdit(event:Event) {
        var notifyEvent = event.convertTo(NotifyEvent);
        notifyEvent.veto();
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
            if (node.data.expandable == true) {
                node.dataViewItem = treeCtrl.appendContainer(null, text, TreeViewIcons.get(_treeview, icon));
            } else {
                node.dataViewItem = treeCtrl.appendItem(null, text, TreeViewIcons.get(_treeview, icon));
            }
            _dataViewItemToNodeMap.set(node.dataViewItem.id, node);
        } else {
            var parentNode = cast(node.parentNode, TreeViewNode); // its a different _type_ of TreeViewNode
            if (parentNode.dataViewItem != null && !treeCtrl.isContainer(parentNode.dataViewItem)) { // we want to change the type from an item to a container since it has childrel (wx widgets is fun!)
                var selectedNode = cast(_treeview.selectedNode, TreeViewNode); // its a different _type_ of TreeViewNode
                if (parentNode.parentNode == null) {
                    var prevNode = treeCtrl.getPrevItem(null, parentNode.dataViewItem);
                    if (prevNode != null) {
                        deleteDataViewItem(parentNode.dataViewItem, false);
                        parentNode.dataViewItem = treeCtrl.insertContainer(null, prevNode, parentNode.data.text, TreeViewIcons.get(_treeview, parentNode.data.icon));
                    } else {
                        deleteDataViewItem(parentNode.dataViewItem, false);
                        parentNode.dataViewItem = treeCtrl.prependContainer(null, parentNode.data.text, TreeViewIcons.get(_treeview, parentNode.data.icon));
                    }
                    _dataViewItemToNodeMap.set(parentNode.dataViewItem.id, parentNode);
                } else {
                    var prevNode = treeCtrl.getPrevItem(cast(parentNode.parentNode, TreeViewNode).dataViewItem, parentNode.dataViewItem);
                    if (prevNode != null) {
                        deleteDataViewItem(parentNode.dataViewItem, false);
                        parentNode.dataViewItem = treeCtrl.insertContainer(cast(parentNode.parentNode, TreeViewNode).dataViewItem, prevNode, parentNode.data.text, TreeViewIcons.get(_treeview, parentNode.data.icon));
                    } else {
                        deleteDataViewItem(parentNode.dataViewItem, false);
                        parentNode.dataViewItem = treeCtrl.prependContainer(cast(parentNode.parentNode, TreeViewNode).dataViewItem, parentNode.data.text, TreeViewIcons.get(_treeview, parentNode.data.icon));
                    }
                    _dataViewItemToNodeMap.set(parentNode.dataViewItem.id, parentNode);
                }
                if (selectedNode != null) {
                    treeCtrl.pauseEvent(EventType.DATAVIEW_SELECTION_CHANGED);
                    treeCtrl.selection = selectedNode.dataViewItem;
                    treeCtrl.unpauseEvent(EventType.DATAVIEW_SELECTION_CHANGED);
                }
            }
            if (node.data.expandable == true) {
                node.dataViewItem = treeCtrl.appendContainer(parentNode.dataViewItem, text, TreeViewIcons.get(_treeview, icon));
            } else {
                node.dataViewItem = treeCtrl.appendItem(parentNode.dataViewItem, text, TreeViewIcons.get(_treeview, icon));
            }
            _dataViewItemToNodeMap.set(node.dataViewItem.id, node);
            parentNode.applyExpanded();
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