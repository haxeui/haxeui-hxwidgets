package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.ImageLoader;
import hx.widgets.AnyButton;
import hx.widgets.StaticBitmap;

class ControlBitmap extends DataBehaviour {
    public override function validateData() {
        var imageLoader:ImageLoader = new ImageLoader(_value);
        imageLoader.load(function(imageInfo) {
            if (imageInfo != null) {
                if ((_component.window is AnyButton)) {
                    var button:AnyButton = cast _component.window;
                    button.bitmap = imageInfo.data;
                } else if ((_component.window is StaticBitmap)) {
                    var bmp:StaticBitmap = cast _component.window;
                    bmp.bitmap = imageInfo.data;
                    if (bmp.parent != null) {
                        bmp.parent.refresh(); // if bitmap has resized, get rid of any left of artifacts from parent (wx thang!)
                    }
                    _component.invalidateComponentLayout();
                }
            }
        });
    }
}
