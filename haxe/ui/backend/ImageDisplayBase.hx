package haxe.ui.backend;

import haxe.ui.core.Component;
import haxe.ui.util.Rectangle;
import haxe.ui.assets.ImageInfo;

class ImageDisplayBase {
    private var _left:Float;
    private var _top:Float;
    private var _imageWidth:Float;
    private var _imageHeight:Float;
    private var _imageInfo:ImageInfo;
    private var _imageClipRect:Rectangle;
 
    public var parentComponent:Component;
    
    public function new() {
    }

    private function validateData() {
        
    }
    
    private function validateStyle():Bool {
        return false;
    }
    
    private function validatePosition() {
        
    }
    
    private function validateDisplay() {
        
    }
}