package haxe.ui.backend;

import haxe.ui.core.Screen;
import hx.widgets.EventType;
import hx.widgets.ThreadEvent;

class CallLaterBase {
    private var _fn:Void->Void;
    
    public function new(fn:Void->Void) {
        _fn = fn;
        Screen.instance.frame.bind(EventType.THREAD, onThreadEvent);
        Screen.instance.frame.queueEvent(new ThreadEvent());
    }
    
    private function onThreadEvent(e) {
        Screen.instance.frame.unbind(EventType.THREAD, onThreadEvent);
        _fn();
    }
}