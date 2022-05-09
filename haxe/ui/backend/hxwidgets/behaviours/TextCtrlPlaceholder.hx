package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.TextCtrl;

class TextCtrlPlaceholder extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        if (_component.window == null) {
            return;
        }
        
        if (!(_component.window is TextCtrl)) {
            return;
        }
        
        var textCtrl = cast(_component.window, TextCtrl);
        textCtrl.hint = value;
    }
    
    public override function get():Variant {
        if (!(_component.window is TextCtrl)) {
            return null;
        }
        
        var textCtrl = cast(_component.window, TextCtrl);
        return textCtrl.hint;
    }
}
