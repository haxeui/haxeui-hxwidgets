package haxe.ui.backend.hxwidgets.handlers;

import haxe.ui.styles.Style;
import hx.widgets.styles.TextCtrlStyle;

class TextCtrlHandler extends NativeHandler {
    public override function applyStyle(style:Style):Bool {
        if (style.textAlign != null) {
            var alignStyle:Int = switch(style.textAlign) {
                case "center": TextCtrlStyle.CENTRE;
                case "right": TextCtrlStyle.RIGHT;
                default: TextCtrlStyle.LEFT;
            }
            window.windowStyle = (window.windowStyle & ~(TextCtrlStyle.LEFT | TextCtrlStyle.RIGHT | TextCtrlStyle.CENTRE))   //Remove old align
                                | alignStyle;
        }
        return true;
    }
}