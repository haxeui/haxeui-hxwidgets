package haxe.ui.backend.hxwidgets;
import hx.widgets.EventType;

class EventTypeParser {
    public static function fromString(event:String):Int {
        if (event == null || event.length == 0) {
            return 0;
        }
        
        switch (event) {
            case "EventType.SLIDER":                        return EventType.SLIDER;
            case "EventType.BUTTON":                        return EventType.BUTTON;
            case "EventType.HYPERLINK":                     return EventType.HYPERLINK;
            case "EventType.TOGGLEBUTTON":                  return EventType.TOGGLEBUTTON;
            case "EventType.NOTEBOOK_PAGE_CHANGED":         return EventType.NOTEBOOK_PAGE_CHANGED;
            case "EventType.RADIOBUTTON":                   return EventType.RADIOBUTTON;
            case "EventType.CHECKBOX":                      return EventType.CHECKBOX;
            case "EventType.CHOICE":                        return EventType.CHOICE;
            case "EventType.LIST_ITEM_SELECTED":            return EventType.LIST_ITEM_SELECTED;
            case "EventType.TEXT":                          return EventType.TEXT;
            case "EventType.MENU":                          return EventType.MENU;
            case "EventType.SPINCTRL":                      return EventType.SPINCTRL;
            case "EventType.SPINCTRLDOUBLE":                return EventType.SPINCTRLDOUBLE;
            case "EventType.CALENDAR_SEL_CHANGED":          return EventType.CALENDAR_SEL_CHANGED;
            case "EventType.DATAVIEW_SELECTION_CHANGED":    return EventType.DATAVIEW_SELECTION_CHANGED;
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
        } else if (eventType == EventType.HYPERLINK) {
            return "EventType.HYPERLINK";
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
        } else if (eventType == EventType.MENU) {
            return "EventType.MENU";
        } else if (eventType == EventType.SPINCTRL) {
            return "EventType.SPINCTRL";
        } else if (eventType == EventType.CALENDAR_SEL_CHANGED) {
            return "EventType.CALENDAR_SEL_CHANGED";
        } else if (eventType == EventType.DATAVIEW_SELECTION_CHANGED) {
            return "EventType.DATAVIEW_SELECTION_CHANGED";
        } else {
            trace('WARNING: hxWidgets event "${eventType}" not recognised');
        }
        
        return null;
    }
}