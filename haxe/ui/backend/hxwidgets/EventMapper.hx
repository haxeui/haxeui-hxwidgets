package haxe.ui.backend.hxwidgets;

import hx.widgets.EventType;

class EventMapper {
    public static var HAXEUI_TO_WX:Map<String, Int> = [
        haxe.ui.events.MouseEvent.MOUSE_MOVE => EventType.MOTION,
        haxe.ui.events.MouseEvent.MOUSE_OVER => EventType.ENTER_WINDOW,
        haxe.ui.events.MouseEvent.MOUSE_OUT => EventType.LEAVE_WINDOW,
        haxe.ui.events.MouseEvent.MOUSE_DOWN => EventType.LEFT_DOWN,
        haxe.ui.events.MouseEvent.MOUSE_UP => EventType.LEFT_UP,
        haxe.ui.events.MouseEvent.MOUSE_WHEEL => EventType.MOUSEWHEEL,
        haxe.ui.events.MouseEvent.RIGHT_CLICK => EventType.RIGHT_UP,
        haxe.ui.events.MouseEvent.CLICK => EventType.BUTTON,
        haxe.ui.events.MouseEvent.DBL_CLICK => EventType.LEFT_DCLICK,
        haxe.ui.events.FocusEvent.FOCUS_IN => EventType.SET_FOCUS,
        haxe.ui.events.FocusEvent.FOCUS_OUT => EventType.KILL_FOCUS
    ];

    public static var WX_TO_HAXEUI:Map<Int, String> = [
        EventType.MOTION => haxe.ui.events.MouseEvent.MOUSE_MOVE,
        EventType.ENTER_WINDOW => haxe.ui.events.MouseEvent.MOUSE_OVER,
        EventType.LEAVE_WINDOW => haxe.ui.events.MouseEvent.MOUSE_OUT,
        EventType.LEFT_DOWN => haxe.ui.events.MouseEvent.MOUSE_DOWN,
        EventType.LEFT_UP => haxe.ui.events.MouseEvent.MOUSE_UP,
        EventType.MOUSEWHEEL => haxe.ui.events.MouseEvent.MOUSE_WHEEL,
        EventType.RIGHT_UP => haxe.ui.events.MouseEvent.RIGHT_CLICK,
        EventType.BUTTON => haxe.ui.events.MouseEvent.CLICK,
        EventType.LEFT_DCLICK => haxe.ui.events.MouseEvent.DBL_CLICK,
        EventType.SET_FOCUS => haxe.ui.events.FocusEvent.FOCUS_IN,
        EventType.KILL_FOCUS => haxe.ui.events.FocusEvent.FOCUS_OUT
    ];
}
