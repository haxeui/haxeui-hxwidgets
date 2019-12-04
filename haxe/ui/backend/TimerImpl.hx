package haxe.ui.backend;

import haxe.ui.backend.hxwidgets.Platform;
import haxe.ui.core.Screen;
import hx.widgets.EventType;
import hx.widgets.Frame;
import hx.widgets.Timer;

class TimerImpl {
    private var _timer:Timer;
    private var _callback:Void->Void;

    public function new(delay:Int, callback:Void->Void) {
        if (Platform.isMac && delay == 0) {
            delay = 1;
        }
        var frame:Frame = Screen.instance.options.frame;
        _callback = callback;
        frame.bind(EventType.TIMER, onTimer);
        _timer = new Timer(frame, delay);
    }

    private function onTimer(e) {
        if (_callback != null) {
            _callback();
        }
    }
    
    public function stop() {
        _callback = null;
        var frame:Frame = Screen.instance.options.frame;
        frame.unbind(EventType.TIMER, onTimer);
        _timer.stop();
        _timer.destroy();
    }
}