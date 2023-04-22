package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.backend.hxwidgets.behaviours.HxWidgetsBehaviour;
import haxe.ui.events.UIEvent;
import haxe.ui.util.Variant;
import hx.widgets.TextCtrl;
import hx.widgets.styles.TextCtrlStyle;

@:access(haxe.ui.backend.ComponentImpl)
class TextCtrlWordWrap extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        if (_component.window == null) {
            return;
        }

        if (value.isNull) {
            return;
        }
        
        var style:Int = TextCtrlStyle.MULTILINE | TextCtrlStyle.HSCROLL;
        if (value == true) {
            style = TextCtrlStyle.MULTILINE;
        }
        
        var eventMap:Map<String, UIEvent->Void> = copyMap(_component._eventMap);
        for (k in eventMap.keys()) { // unmap any events on current window
            _component.unmapEvent(k, eventMap.get(k));
        }
        
        var oldControl:TextCtrl = cast(_component.window, TextCtrl);
        var newControl:TextCtrl = new TextCtrl(oldControl.parent, oldControl.value, style);
        newControl.move(oldControl.position.x, oldControl.position.y);
        newControl.size = oldControl.size;
        newControl.show(oldControl.shown);
        newControl.enabled = oldControl.enabled;
        oldControl.destroy();
        _component.window = newControl;
        _component.invalidateComponentStyle();
        
        for (k in eventMap.keys()) { // remap any events on current window
            _component.mapEvent(k, eventMap.get(k));
        }
    }
    
    public override function get():Variant {
        if (_component.window == null) {
            return false;
        }
        
        return (_component.window.windowStyle & TextCtrlStyle.PASSWORD) == TextCtrlStyle.PASSWORD;
    }
    
    private function copyMap(map:Map<String, UIEvent->Void>):Map<String, UIEvent->Void> {
        var newMap:Map<String, UIEvent->Void> = new Map<String, UIEvent->Void>();
        
        for (k in map.keys()) {
            newMap.set(k, map.get(k));
        }
        
        return newMap;
    }
}
