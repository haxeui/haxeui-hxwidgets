package haxe.ui.backend;

import haxe.ui.core.Screen;
import haxe.ui.util.Timer;
import hx.widgets.EventType;
import hx.widgets.ThreadEvent;

class CallLaterImpl {
    private var _fn:Void->Void;
    
    public function new(fn:Void->Void) {
        var t = null;
        /*
        t = new Timer(0, function() {
            t.stop();
            fn();
        });
        */
        fn(); // actually works nicely like this - no flashing, could be a bottle neck though
        
        /* TODO: causes issues when resizing... obviously pauses main loop when resizing top level frame
        _fn = fn;
        Screen.instance.frame.bind(EventType.THREAD, onThreadEvent);
        Screen.instance.frame.queueEvent(new ThreadEvent());
        */
    }

    /*
    private function onThreadEvent(e) {
        Screen.instance.frame.unbind(EventType.THREAD, onThreadEvent);
        _fn();
    }
    */
}