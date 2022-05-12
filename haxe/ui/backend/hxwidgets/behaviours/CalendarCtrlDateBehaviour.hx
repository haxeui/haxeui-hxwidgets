package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.CalendarCtrl;

class CalendarCtrlDateBehaviour extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        if (_component.window == null) {
            return;
        }

        if (value.isNull) {
            return;
        }
        
        var cal = cast(_component.window, CalendarCtrl);
        cal.date = value;
    }

    public override function get():Variant {
        if (_component.window == null) {
            return null;
        }
        
        var cal = cast(_component.window, CalendarCtrl);
        return cal.date;
    }
}