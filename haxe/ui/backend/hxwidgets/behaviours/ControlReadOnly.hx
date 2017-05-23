package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import haxe.ui.components.TextArea;
import hx.widgets.Bitmap;
import hx.widgets.Control;
import hx.widgets.Button;
import hx.widgets.StaticText;
import hx.widgets.TextCtrl;
import hx.widgets.styles.TextCtrlStyle;

@:keep
@:access(haxe.ui.core.Component)
class ControlReadOnly extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        if (_component.window == null) {
            return;
        }

        var ctrl:Control = cast _component.window;
        if (value.isNull == false) {
            if (Std.is(_component.window, TextCtrl)) {
                var textctrl:TextCtrl = cast _component.window;
                var style = textctrl.windowStyle;

                if (value == false && (style & TextCtrlStyle.READONLY > 0)) {
                    style -= TextCtrlStyle.READONLY;
                }
                if (value == true) {
                    style |= TextCtrlStyle.READONLY;
                }

                var text = textctrl.value;
                var parent =  textctrl.parent;
                var id =  textctrl.id;

                var replacement = new TextCtrl(parent, text, style, id);
                replacement.size = textctrl.size;
                replacement.position = textctrl.position;
                _component.replaceWindow(replacement);
            }
            _component.invalidateLayout();
        }


        var textArea:TextArea = cast _component;
        textArea.getTextInput().readOnly = value;
    }

    public override function get():Variant {
        if (_component.window == null) {
            return null;
        }

        if (Std.is(_component.window, TextCtrl)) {
            var textctrl:TextCtrl = cast _component.window;
            return (textctrl.windowStyle & TextCtrlStyle.READONLY) > 0;
        }

        return null;
    }
}
