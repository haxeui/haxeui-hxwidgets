package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;

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
    }
    
    public override function get():Variant {
        return null;
    }
}