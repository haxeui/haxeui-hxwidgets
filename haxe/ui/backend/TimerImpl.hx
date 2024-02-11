package haxe.ui.backend;

import hx.widgets.TimerEvent;
import hx.widgets.Event;
import haxe.ui.backend.hxwidgets.Platform;
import haxe.ui.core.Screen;
import hx.widgets.EventType;
import hx.widgets.Frame;
import hx.widgets.Timer;

typedef DeferredTimerDetails = {
    var delay:Int;
    var callback:Void->Void;
}

class TimerImpl {
    private var _timer:Timer;
    private var _callback:Void->Void;

    private static var _deferredTimers:Array<DeferredTimerDetails>;
    private static var _nextTimerId:Int = 1;

    private static var count:Int = 0;
    public function new(delay:Int, callback:Void->Void) {
        if (Screen.instance.options == null || Screen.instance.options.frame == null) {
            // its possible that you might want to created timers _before_ hxwidgets
            // is ready, if thats the case, we'll defer them for when hxwidgets _is_ ready
            if (_deferredTimers == null) {
                _deferredTimers = [];
            }
            _deferredTimers.push({
                delay: delay,
                callback: callback
            });
            return;
        }
        
        if (!Platform.isWindows && delay == 0) {
            delay = 1;
        }
        var frame:Frame = Screen.instance.options.frame;
        _callback = callback;
        if (count == 0) {
            frame.bind(EventType.TIMER, onTimer);
        }
        count++;
        _timer = new Timer(frame, delay, false, _nextTimerId);
        _nextTimerId++;
    }

    private static function processDeferredTimers() {
        if (_deferredTimers == null) {
            return;
        }
        
        for (d in _deferredTimers) {
            haxe.ui.util.Timer.delay(d.callback, d.delay);
        }
        
        _deferredTimers = [];
        _deferredTimers = null;
    }
    
    private function onTimer(e:Event) {
        var timerEvent = e.convertTo(TimerEvent);
        var timer = timerEvent.timer;
        if (timer.id == _timer.id) {
            if (_callback != null) {
                _callback();
            }
        }
    }
    
    public function stop() {
        _callback = null;
        var frame:Frame = Screen.instance.options.frame;
        count--;
        if (count == 0) {
            frame.unbind(EventType.TIMER, onTimer);
        }
        if (_timer != null) {
            _timer.stop();
            _timer.destroy();
            _timer = null;
        }
    }
}