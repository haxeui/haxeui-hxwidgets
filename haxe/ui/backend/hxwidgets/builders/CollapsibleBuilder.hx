package haxe.ui.backend.hxwidgets.builders;

import haxe.ui.containers.Header;
import haxe.ui.core.Component;
import haxe.ui.core.CompositeBuilder;
import hx.widgets.CollapsiblePane as NativeCollapsiblePane;
import hx.widgets.EventType;

class CollapsibleBuilder extends CompositeBuilder {
    private var _cachedChildren:Array<Component> = [];

    public override function onInitialize() {
        super.onInitialize();

        var nativeCollapsiblePane = cast(_component.window, NativeCollapsiblePane);
        var content = nativeCollapsiblePane.getPane();
        for (child in _cachedChildren) {
            @:privateAccess child.createWindow(content);
            child.ready();
        }

        nativeCollapsiblePane.bind(EventType.COLLAPSIBLEPANE_CHANGED, onNativeCollapsiblePaneChanged);
    }

    private function onNativeCollapsiblePaneChanged(_) {
        // size of component has changed, lets recalc layout and shift everything appropriately
        _component.invalidateComponentLayout();
    }

    public override function addComponent(child:Component):Component {
        if ((child is Header)) {
            return child;
        }
        _cachedChildren.push(child);
        return child;
    }
}