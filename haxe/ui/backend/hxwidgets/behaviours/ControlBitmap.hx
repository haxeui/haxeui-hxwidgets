package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.ImageLoader;
import hx.widgets.AnyButton;
import hx.widgets.Bitmap;
import hx.widgets.Image;
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
                    var scale:Float = 1;
                    if ((_component is haxe.ui.components.Image)) {
                        scale = cast(_component, haxe.ui.components.Image).imageScale;
                    }
                    var bmp:StaticBitmap = cast _component.window;
                    var bitmap:Bitmap = imageInfo.data;
                    if (scale != 1) {
                        var img:Image = bitmap.convertToImage();
                        var scaledImg = img.scale(Std.int(img.width * scale), Std.int(img.height * scale));
                        var scaledBitmap = new Bitmap(scaledImg);
                        img.destroy();
                        bitmap.destroy();
                        bitmap = scaledBitmap;
                        scaledImg.destroy();
                    }
                    bmp.bitmap = bitmap;
                    if (bmp.parent != null) {
                        bmp.parent.refresh(); // if bitmap has resized, get rid of any left of artifacts from parent (wx thang!)
                    }
                    _component.invalidateComponentLayout();
                }
            }
        });
    }
}
