package haxe.ui.backend;

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
        
        if (Platform.isMac && delay == 0) {
            delay = 1;
        }
        var frame:Frame = Screen.instance.options.frame;
        _callback = callback;
        frame.bind(EventType.TIMER, onTimer);
        _timer = new Timer(frame, delay);
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
    
    private function onTimer(e) {
        if (_callback != null) {
            _callback();
        }
    }
    
    public function stop() {
        _callback = null;
        var frame:Frame = Screen.instance.options.frame;
        frame.unbind(EventType.TIMER, onTimer);
        if (_timer != null) {
            _timer.stop();
            _timer.destroy();
            _timer = null;
        }
    }
}