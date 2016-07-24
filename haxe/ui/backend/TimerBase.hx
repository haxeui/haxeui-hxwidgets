package haxe.ui.backend;

import haxe.ui.core.Screen;
import hx.widgets.EventType;
import hx.widgets.Frame;
import hx.widgets.Timer;

class TimerBase {
    private var _timer:Timer;

    public function new(delay:Int, callback:Void->Void) {
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