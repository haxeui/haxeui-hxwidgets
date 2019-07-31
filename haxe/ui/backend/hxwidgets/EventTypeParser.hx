package haxe.ui.backend.hxwidgets;
import hx.widgets.EventType;

class EventTypeParser {
    public static function fromString(event:String):Int {
        if (event == null || event.length == 0) {
            return 0;
        }
        
        switch (event) {
            case "EventType.SLIDER":                return EventType.SLIDER;
            case "EventType.BUTTON":                return EventType.BUTTON;
            case "EventType.TOGGLEBUTTON":          return EventType.TOGGLEBUTTON;
            case "EventType.NOTEBOOK_PAGE_CHANGED": return EventType.NOTEBOOK_PAGE_CHANGED;
            case "EventType.RADIOBUTTON":           return EventType.RADIOBUTTON;
            case "EventType.CHECKBOX":              return EventType.CHECKBOX;
            case "EventType.CHOICE":                return EventType.CHOICE;
            case "EventType.LIST_ITEM_SELECTED":    return EventType.LIST_ITEM_SELECTED;
            case "EventType.TEXT":                  return EventType.TEXT;
            default:
                trace('WARNING: hxWidgets event "${event}" not recognised');
        }
        
        return 0;
    }
    
    public static function toString(eventType:Int):String {
        if (eventType == EventType.SLIDER) {
            return "EventType.SLIDER";
        } else if (eventType == EventType.BUTTON) {
            return "EventType.BUTTON";
        } else if (eventType == EventType.TOGGLEBUTTON) {
            return "EventType.TOGGLEBUTTON";
        } else if (eventType == EventType.NOTEBOOK_PAGE_CHANGED) {
            return "EventType.NOTEBOOK_PAGE_CHANGED";
        } else if (eventType == EventType.RADIOBUTTON) {
            return "EventType.RADIOBUTTON";
        } else if (eventType == EventType.CHECKBOX) {
            return "EventType.CHECKBOX";
        } else if (eventType == EventType.CHOICE) {
            return "EventType.CHOICE";
        } else if (eventType == EventType.LIST_ITEM_SELECTED) {
            return "EventType.LIST_ITEM_SELECTED";
        } else if (eventType == EventType.TEXT) {
            return "EventType.TEXT";
        } else {
            trace('WARNING: hxWidgets event "${eventType}" not recognised');
        }
        
        return null;
    }
}