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
        if (_component.window == null) {
            return;
        }

        var ctrl:Control = cast(_component.window, Control);
        if (_value != null) {
            var normalizedValue = normalizeText(_value);
            _component.set("originalLabel", normalizedValue); // for wrapping, see: haxe.ui.backend.hxwidgets.size.BestSize
            ctrl.label = normalizedValue;
            _component.invalidateComponentLayout();
            _component.invalidateComponentStyle();
        } else {
            _component.set("originalLabel", null);
        }
    }
    
    private inline function normalizeText(s:String) {
        s = StringTools.replace(s, "\\n", "\r\n");
        return s;
    }
}
