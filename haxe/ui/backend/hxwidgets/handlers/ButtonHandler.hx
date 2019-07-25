package haxe.ui.backend.hxwidgets.handlers;

import haxe.ui.styles.Style;
import hx.widgets.Button;
import hx.widgets.Direction;
import hx.widgets.styles.ButtonStyle;

class ButtonHandler extends NativeHandler {
    public override function applyStyle(style:Style):Bool {
        var button:Button = cast(_component.window, Button);
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