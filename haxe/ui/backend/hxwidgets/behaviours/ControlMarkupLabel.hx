package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import hx.widgets.Control;

@:access(haxe.ui.core.Component)
class ControlMarkupLabel extends DataBehaviour {
    
    public override function validateData() {
        if (_component.window == null) {
            return;
        }

        var ctrl:Control = cast(_component.window, Control);
        if (_value != null) {
            _component.set("originalLabel", _value.toString()); // for wrapping, see: haxe.ui.backend.hxwidgets.size.BestSize
            ctrl.setLabelMarkup(normalizeText(_value));
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
