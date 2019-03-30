package haxe.ui.backend;

import haxe.io.Bytes;
import haxe.ui.assets.ImageInfo;
import hx.widgets.Bitmap;

class AssetsImpl extends AssetsBase {
    private override function getImageInternal(resourceId:String, callback:ImageInfo->Void):Void {
        imageFromBytes(Resource.getBytes(resourceId), callback);
    }

    private override function getImageFromHaxeResource(resourceId:String, callback:String->ImageInfo->Void) {
        imageFromBytes(Resource.getBytes(resourceId), function(imageInfo) {
            callback(resourceId, imageInfo);
        });
    }

    public override function imageFromBytes(bytes:Bytes, callback:ImageInfo->Void) {
        if (bytes == null) {
            callback(null);
        }
        
        var bmp = Bitmap.fromHaxeBytes(bytes);
        if (bmp.isOk == false) {
            callback(null);
        }
        
        callback({
            data: bmp,
            width: bmp.width,
            height: bmp.height
        });
    }
}