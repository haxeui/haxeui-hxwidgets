package haxe.ui.backend;
import haxe.ui.assets.ImageInfo;

class ImageDisplayBase {
    public function new() {
    }

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
}