package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.backend.hxwidgets.custom.TransparentStaticBitmap;
import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;

class ImageScaleMode extends DataBehaviour {
    public override function validateData() {
        if (_component.window == null) {
            return;
        }
      
        var bitmap = cast(_component.window, TransparentStaticBitmap);
        bitmap.scaleMode = _value;
    }
}