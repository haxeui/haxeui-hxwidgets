package haxe.ui.backend;

import haxe.ui.events.UIEvent;
import hx.widgets.Event;

@:allow(haxe.ui.backend.ComponentImpl)
@:allow(haxe.ui.backend.ScreenImpl)
class EventImpl extends EventBase {
    private var _originalEvent:Event;

    public override function cancel() {
        if (_originalEvent != null) {
            _originalEvent.skip(false);
            _originalEvent.stopPropagation();
        }
    }

    private override function postClone(event:UIEvent) {
        event._originalEvent = this._originalEvent;
    }
}
