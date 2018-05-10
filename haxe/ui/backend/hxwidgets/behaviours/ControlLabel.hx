package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.Bitmap;
import hx.widgets.Control;
import hx.widgets.Button;
import hx.widgets.StaticText;
import hx.widgets.TextCtrl;

@:keep
@:access(haxe.ui.core.Component)
class ControlLabel extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        if (_component.window == null) {
            return;
        }

        var ctrl:Control = cast _component.window;
        if (value.isNull == false) {
            if (Std.is(_component.window, TextCtrl)) {
                var textctrl:TextCtrl = cast _component.window;
                textctrl.value = normalizeText(value);
            } else {
                ctrl.label = normalizeText(value);
            }
            _component.invalidateComponentLayout();
        }
    }

    public override function get():Variant {
        if (_component.window == null) {
            return null;
        }

        if (Std.is(_component.window, TextCtrl)) {
            var textctrl:TextCtrl = cast _component.window;
            return textctrl.value;
        }

        var ctrl:Control = cast _component.window;
        return ctrl.label;
    }

    private function normalizeText(s:String) {
        s = StringTools.replace(s, "\\n", "\r\n");
        return s;
    }
}