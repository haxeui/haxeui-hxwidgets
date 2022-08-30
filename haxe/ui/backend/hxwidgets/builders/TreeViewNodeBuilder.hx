package haxe.ui.backend.hxwidgets.builders;

import haxe.ui.backend.hxwidgets.custom.TreeViewNode;
import haxe.ui.core.CompositeBuilder;

class TreeViewNodeBuilder extends CompositeBuilder {
    private var _node:TreeViewNode;
    public function new(node:TreeViewNode) {
        super(node);
        _node = node;
    }
}