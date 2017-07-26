package haxe.ui.backend;

import haxe.ui.util.Rectangle;
import haxe.ui.assets.ImageInfo;

class ImageDisplayBase {
    private var _left:Float;
    private var _top:Float;
    private var _imageWidth:Float;
    private var _imageHeight:Float;
    private var _imageInfo:ImageInfo;
    private var _imageClipRect:Rectangle;
    
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
    
    /*
    public var aspectRatio:Float = 1; // width x height

    private var _left:Float = 0;
    public var left(get, set):Float;
    private function get_left():Float {
        return _left;
    }
    private function set_left(value:Float):Float {
        if (value == _left) {
            return value;
        }

        _left = value;
        return value;
    }

    private var _top:Float = 0;
    public var top(get, set):Float;
    private function get_top():Float {
        return _top;
    }
    private function set_top(value:Float):Float {
        if (value == _top) {
            return value;
        }

        _top = value;
        return value;
    }

    private var _imageWidth:Float = 0;
    public var imageWidth(get, set):Float;
    public function set_imageWidth(value:Float):Float {
        if (_imageWidth == value || value <= 0) {
            return value;
        }
        _imageWidth = value;
        return value;
    }

    public function get_imageWidth():Float {
        return _imageWidth;
    }

    private var _imageHeight:Float = 0;
    public var imageHeight(get, set):Float;
    public function set_imageHeight(value:Float):Float {
        if (_imageHeight == value || value <= 0) {
            return value;
        }
        _imageHeight = value;
        return value;
    }

    public function get_imageHeight() {
        return _imageHeight;
    }

    private var _imageInfo:ImageInfo;
    public var imageInfo(get, set):ImageInfo;
    private function get_imageInfo():ImageInfo {
        return _imageInfo;
    }
    private function set_imageInfo(value:ImageInfo):ImageInfo {
        return value;
    }

    public function dispose() {
    }

    public var imageClipRect(get, set):Rectangle;

    private var _imageClipRect:Rectangle;
    public function get_imageClipRect():Rectangle {
        return _imageClipRect;
    }
    private function set_imageClipRect(value:Rectangle):Rectangle {
        _imageClipRect = value;

        //TODO
        if(value == null) {

        } else {

        }

        return value;
    }
    */
}