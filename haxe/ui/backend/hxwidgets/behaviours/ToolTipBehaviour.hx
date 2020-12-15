package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;

class ToolTipBehaviour extends DataBehaviour {
    public override function validateData() {
        if (_value == null || _value.isNull) {
            _component.window.toolTip = null;
        } else {
            _component.window.toolTip = extractTip(Variant.toDynamic(_value));
        }
    }
    
    private var _cachedValue:Dynamic;
    public override function setDynamic(value:Dynamic) {
        if (_cachedValue == value) {
            return;
        }
        _cachedValue = value;
        if (_component.window == null) {
            return;
        }
        if (value == null) {
            _component.window.toolTip = null;
        } else {
            _component.window.toolTip = extractTip(value);
        }
    }
    
    public override function update() {
        var t = _cachedValue;
        _cachedValue = null;
        setDynamic(t);
    }
    
    public override function getDynamic():Dynamic {
        if (_component.window == null) {
            return null;
        }
        return _component.window.toolTip;
    }
    
    private function extractTip(value:Dynamic) {
        var s = value;
        if (Type.typeof(value) == TObject) {
            if (value.text != null) {
                s = value.text;
            } else if (value.tooltip != null) {
                s = value.tooltip;
            }
        }
        return s;
    }
}