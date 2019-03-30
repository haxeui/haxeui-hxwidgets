package haxe.ui.backend;

import haxe.ui.backend.hxwidgets.Platform;
import haxe.ui.core.Screen;
import hx.widgets.EventType;
import hx.widgets.Frame;
import hx.widgets.Timer;

class TimerImpl {
    private var _timer:Timer;

    public function new(delay:Int, callback:Void->Void) {
        if (Platform.isMac && delay == 0) {
            delay = 1;
        }
        var frame:Frame = Screen.instance.options.frame;
        _timer = new Timer(frame, delay);
        frame.bind(EventType.TIMER, function(e) {
           callback();
        });
    }

    public function stop() {
        _timer.stop();
    }
}