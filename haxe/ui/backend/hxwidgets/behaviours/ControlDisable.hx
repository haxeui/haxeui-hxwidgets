package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;

@:access(haxe.ui.core.Component)
class ControlDisable extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        if (_component.window == null) {
            return;
        }

        if (value.isNull) {
            return;
        }
        
        _component.window.enabled = !value;
        _component.disableInteractiveEvents(value);
    }
    
    public override function get():Variant {
        return _value;
    }
}