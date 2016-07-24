package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.Bitmap;
import hx.widgets.Button;
import hx.widgets.Control;
import hx.widgets.Direction;
import hx.widgets.Image;
import hx.widgets.StaticBitmap;
import hx.widgets.styles.ButtonStyle;

class ControlBitmap extends HxWidgetsBehaviour {
    public override function set(value:Variant) {
        super.set(value);
        if (_component.window == null) {
            return;
        }
        
        if (value.isNull) {
            return;
        }

        if (Std.is(_component.window, Button)) {
            if (Resource.getBytes(value) != null) {
                var button:Button = cast _component.window;
                button.bitmap = Bitmap.fromHaxeResource(value);
            }
        } else if (Std.is(_component.window, StaticBitmap)) {
            if (Resource.getBytes(value) != null) {
                var bmp:StaticBitmap = cast _component.window;
                bmp.bitmap = Bitmap.fromHaxeResource(value);
            }
        }
    }
    
    public override function get():Variant {
        /*
        if (_component.window == null) {
            return null;
        }
        var ctrl:Control = cast _component.window;
        */
        return null;
    }
}