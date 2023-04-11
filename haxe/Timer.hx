package haxe;

// TODO: consider wiring up event loop in wx: https://github.com/Apprentice-Alchemist/Arcane/blob/dev/src/arcane/Lib.hx#L63-L75
// On threaded targets, call the events.progress thing.
// On other targets MainLoop.tick.
class Timer  {
    private var _timer:haxe.ui.util.Timer = null;

    private var _time_ms:Int;
    public function new(time_ms:Int) {
        _time_ms = time_ms;
    }

    public var run(null, set):Void->Void;
    private function set_run(value:Void->Void):Void->Void {
        if (_timer == null) {
            _timer = new haxe.ui.util.Timer(_time_ms, value);
        }
        return value;
    }

    public function stop() {
        if (_timer != null) {
            _timer.stop();
            _timer = null;
        }
    }

    public static function stamp():Float {
        return 0;
    }

    public static function delay(f:Void->Void, time_ms:Int):Timer {
        var timer = new Timer(time_ms);
        timer.run = f;
        return timer;
    }
}