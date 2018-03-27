package haxe.ui.backend;

import haxe.io.Bytes;
import haxe.ui.assets.FontInfo;
import haxe.ui.assets.ImageInfo;
import hx.widgets.Bitmap;

class AssetsBase {
    public function new() {
    }

    private function getTextDelegate(resourceId:String):String {
        return null;
    }

    private function getImageInternal(resourceId:String, callback:ImageInfo->Void):Void {
        imageFromBytes(Resource.getBytes(resourceId), callback);
    }

    private function getImageFromHaxeResource(resourceId:String, callback:String->ImageInfo->Void) {
        imageFromBytes(Resource.getBytes(resourceId), function(imageInfo) {
            callback(resourceId, imageInfo);
        });
    }

    public function imageFromBytes(bytes:Bytes, callback:ImageInfo->Void) {
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
    
    private function getFontInternal(resourceId:String, callback:FontInfo->Void):Void {
        callback(null);
    }

    private function getFontFromHaxeResource(resourceId:String, callback:String->FontInfo->Void) {
        callback(resourceId, null);
    }
}