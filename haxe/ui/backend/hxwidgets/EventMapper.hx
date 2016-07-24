package haxe.ui.backend.hxwidgets;
import hx.widgets.EventType;

class EventMapper {
    public static var HAXEUI_TO_WX:Map<String, Int> = [
        haxe.ui.core.MouseEvent.MOUSE_MOVE => EventType.MOTION,
        haxe.ui.core.MouseEvent.MOUSE_OVER => EventType.ENTER_WINDOW,
        haxe.ui.core.MouseEvent.MOUSE_OUT => EventType.LEAVE_WINDOW,
        haxe.ui.core.MouseEvent.MOUSE_DOWN => EventType.LEFT_DOWN,
        haxe.ui.core.MouseEvent.MOUSE_UP => EventType.LEFT_UP,
        haxe.ui.core.MouseEvent.CLICK => EventType.BUTTON
    ];

    public static var WX_TO_HAXEUI:Map<Int, String> = [
        EventType.MOTION => haxe.ui.core.MouseEvent.MOUSE_MOVE,
        EventType.ENTER_WINDOW => haxe.ui.core.MouseEvent.MOUSE_OVER,
        EventType.LEAVE_WINDOW => haxe.ui.core.MouseEvent.MOUSE_OUT,
        EventType.LEFT_DOWN => haxe.ui.core.MouseEvent.MOUSE_DOWN,
        EventType.LEFT_UP => haxe.ui.core.MouseEvent.MOUSE_UP,
        EventType.BUTTON => haxe.ui.core.MouseEvent.CLICK
    ];
}