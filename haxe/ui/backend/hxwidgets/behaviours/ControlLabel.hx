package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import hx.widgets.Bitmap;
import hx.widgets.Control;
import hx.widgets.Button;
import hx.widgets.StaticText;
import hx.widgets.TextCtrl;

@:access(haxe.ui.core.Component)
class ControlLabel extends DataBehaviour {
    public override function get():Variant {
        if (_component.window == null) {
            return null;
        }
        var ctrl:Control = cast(_component.window, Control);
        var label = ctrl.label;
        if ((_component.window is TextCtrl)) {
            label = cast(_component.window, TextCtrl).value;
        }
        
        return label;
    }
    
    public override function validateData() {
        var ctrl:Control = cast(_component.window, Control);
        if (_value != null) {
            _component.set("originalLabel", _value.toString()); // for wrapping, see: haxe.ui.backend.hxwidgets.size.BestSize
            ctrl.label = normalizeText(_value);
            _component.invalidateComponentLayout();
        } else {
            _component.set("originalLabel", null);
        }
    }
    
    private inline function normalizeText(s:String) {
        s = StringTools.replace(s, "\\n", "\r\n");
        return s;
    }
}
