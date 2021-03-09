package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.Gauge;

@:keep
class ControlPulse extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        if (_component.window == null) {
            return;
        }

        if ((_component.window is Gauge) && value == true) {
            cast(_component.window, Gauge).pulse();
        }
    }
}