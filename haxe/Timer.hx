package haxe;

import hx.widgets.App;
import hx.widgets.Timer as WxTimer;
import hx.widgets.Event;
import hx.widgets.TimerEvent;
import hx.widgets.EventType;
import cpp.Finalizable;

class Timer extends Finalizable {
    private static var _nextId:Int = 0;
    private var _id:Int;
    private var _time_ms:Int;
    private var _timer:WxTimer = null;

    private static var _instances:Array<Timer> = [];

    public function new(time_ms:Int) {
        super();
        _time_ms = time_ms;
        _nextId++;
        _id = _nextId;
        _instances.push(this);
    }

    public override function finalize() {
        stop();
        super.finalize();
    }

    private static function stopAll() {
        for (t in _instances) {
            t.stop();
        }
    }

    public function stop() {
        if (_timer != null) {
            App.instance.topWindow.unbind(EventType.TIMER, onTimer);
            _timer.stop();
            _timer = null;
        }
    }

    private var _fn:Void->Void = null;
    public var run(null, set):Void->Void;
    private function set_run(value:Void->Void):Void->Void {
        if (_timer != null) {
            stop();
        }
        _fn = value;
        _timer = new WxTimer(App.instance.topWindow, _time_ms, false, _id);
        App.instance.topWindow.bind(EventType.TIMER, onTimer);
        return value;
    }

    private function onTimer(event:Event) {
        if (_fn == null) {
            return;    
        }

        var timerEvent = event.convertTo(TimerEvent);
        if (timerEvent.timer.id == _id) {
            _fn();
        }
    }

	public static function delay(f:Void->Void, time_ms:Int) {
		var t = new haxe.Timer(time_ms);
		t.run = function() {
			t.stop();
			f();
		};
		return t;
	}

    public static inline function stamp():Float {
        return untyped __global__.__time_stamp();
    }
}
