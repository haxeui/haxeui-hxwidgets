package haxe.ui.backend.hxwidgets;
import hx.widgets.EventType;

class EventTypeParser {
    public static function parseEvent(event:String):Int {
        if (event == null || event.length == 0) {
            return 0;
        }
        
        switch (event) {
            case "EventType.SLIDER":            return EventType.SLIDER;
            case "EventType.BUTTON":            return EventType.BUTTON;
            case "EventType.TOGGLEBUTTON":      return EventType.TOGGLEBUTTON;
            default:
                trace('WARNING: hxWidgets event "${event}" not recognised');
        }
        
        return 0;
    }
}