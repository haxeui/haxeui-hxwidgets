package haxe.ui.backend.hxwidgets.creators;

import hx.widgets.styles.TextCtrlStyle;
import hx.widgets.Window;
import haxe.ui.components.TextField;

class TextCtrlCreator extends Creator {

    public override function createStyle(style:Int):Int {
        if ((_component is TextField)) {
            style |= TextCtrlStyle.PROCESS_ENTER;
        }
        return style;
    }

}
