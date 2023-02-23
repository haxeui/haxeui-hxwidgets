package haxe.ui.backend.hxwidgets.handlers;

import hx.widgets.Event;
import hx.widgets.EventType;

class LinkHandler extends NativeHandler {
    public override function link() {
        _component.window.bind(EventType.HYPERLINK, __onClick);
    }
    
    public override function unlink() {
        _component.window.unbind(EventType.HYPERLINK, __onClick);
    }

    private function __onClick(event:Event) {
        event.stopPropagation();
        event.skip(false);
    }
}