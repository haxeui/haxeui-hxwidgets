package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.core.Behaviour;
import haxe.ui.util.Variant;

class HxWidgetsBehaviour extends Behaviour {
    private var _value:Variant;
    public override function set(value:Variant) {
        _value = value;
    }

    public override function update() {
        set(_value);
    }
}