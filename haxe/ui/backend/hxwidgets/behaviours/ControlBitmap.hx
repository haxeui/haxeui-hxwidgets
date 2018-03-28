package haxe.ui.backend.hxwidgets.behaviours;

import haxe.Http;
import haxe.io.Bytes;
import haxe.ui.core.DataBehaviour;
import haxe.ui.util.Variant;
import haxe.ui.util.ImageLoader;
import hx.widgets.Bitmap;
import hx.widgets.Button;
import hx.widgets.Control;
import hx.widgets.Direction;
import hx.widgets.Image;
import hx.widgets.StaticBitmap;
import hx.widgets.styles.ButtonStyle;

class ControlBitmap extends DataBehaviour {
    public override function validateData() {
        var imageLoader:ImageLoader = new ImageLoader(_value);
        imageLoader.load(function(imageInfo) {
            if (imageInfo != null) {
                if (Std.is(_component.window, Button)) {
                    var button:Button = cast _component.window;
                    button.bitmap = imageInfo.data;
                } else if (Std.is(_component.window, StaticBitmap)) {
                    var bmp:StaticBitmap = cast _component.window;
                    bmp.bitmap = imageInfo.data;
                    if (bmp.parent != null) {
                        bmp.parent.refresh(); // if bitmap has resized, get rid of any left of artifacts from parent (wx thang!)
                    }
                    _component.invalidateLayout();
                }
            }
        });
    }
}

/*
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
            var imageLoader:ImageLoader = new ImageLoader(value);
            imageLoader.load(function(imageInfo) {
                if (imageInfo != null) {
                    var bmp:StaticBitmap = cast _component.window;
                    bmp.bitmap = imageInfo.data;
                    if (bmp.parent != null) {
                        bmp.parent.refresh(); // if bitmap has resized, get rid of any left of artifacts from parent (wx thang!)
                    }
                    _component.invalidateLayout();
                }
            });
        }
    }

    public override function get():Variant {
        return _value;
    }
}
*/