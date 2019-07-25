package haxe.ui.backend.hxwidgets.handlers;

import haxe.ui.styles.Style;
import hx.widgets.styles.StaticTextStyle;

class StaticTextHandler extends NativeHandler {
    public override function applyStyle(style:Style):Bool {
        if (style.textAlign != null) {
            var alignStyle:Int = switch(style.textAlign) {
                case "center": StaticTextStyle.ALIGN_CENTRE_HORIZONTAL;
                case "right": StaticTextStyle.ALIGN_RIGHT;
                default: StaticTextStyle.ALIGN_LEFT;
            }
            window.windowStyle = (window.windowStyle & ~(StaticTextStyle.ALIGN_LEFT | StaticTextStyle.ALIGN_RIGHT | StaticTextStyle.ALIGN_CENTRE_HORIZONTAL))   //Remove old align
                                | alignStyle;
        }
        return true;
    }
}