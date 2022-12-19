package haxe.ui.backend.hxwidgets.handlers;

import hx.widgets.ToggleButton;
import haxe.ui.styles.Style;
import hx.widgets.AnyButton;
import hx.widgets.Direction;
import hx.widgets.styles.ButtonStyle;
import hx.widgets.Event;
import hx.widgets.EventType;
import haxe.ui.components.Button.ButtonGroups;

class ButtonHandler extends NativeHandler {
    public override function link() {
        _component.window.bind(EventType.TOGGLEBUTTON, __onToggleEvent);
    }
    
    public override function unlink() {
        _component.window.unbind(EventType.TOGGLEBUTTON, __onToggleEvent);
    }
    
    private function __onToggleEvent(event:Event) {
        ButtonGroups.instance.setSelection(cast _component, cast(_component.window, ToggleButton).value);
    }

    public override function applyStyle(style:Style):Bool {
        var button:AnyButton = cast(_component.window, AnyButton);
        switch (style.iconPosition) {
            case "right":
                button.bitmapPosition = Direction.RIGHT;
            case "top":
                button.bitmapPosition = Direction.TOP;
            case "bottom":
                button.bitmapPosition = Direction.BOTTOM;
            default:
                button.bitmapPosition = Direction.LEFT;
        }
        
        if (style.textAlign != null) {
            var alignStyle:Int = switch(style.textAlign) {
                case "left": ButtonStyle.LEFT;
                case "right": ButtonStyle.RIGHT;
                default: 0;
            }
            window.windowStyle = (window.windowStyle & ~(ButtonStyle.LEFT | ButtonStyle.RIGHT))   //Remove old align
                                | alignStyle;
        }
        return true;
    }
}