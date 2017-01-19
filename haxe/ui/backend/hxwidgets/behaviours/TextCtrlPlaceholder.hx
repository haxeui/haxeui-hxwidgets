package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;

class TextCtrlPlaceholder extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        if (_component.window == null) {
            return;
        }
    }
    
    public override function get():Variant {
        return null;
    }
}