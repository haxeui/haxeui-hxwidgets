package haxe.ui.backend;
import haxe.ui.styles.Style;

class TextDisplayBase {
    public function new() {
    }

    private var _text:String;
    public var text(get, set):String;
    private function get_text():String {
        return _text;
    }
    private function set_text(value:String):String {
        if (value == _text) {
            return value;
        }

        _text = value;
        return value;
    }

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

    private var _width:Float = -1;
    public var width(get, set):Float;
    public function set_width(value:Float):Float {
        if (_width == value) {
            return value;
        }
        _width = value;
        return value;
    }

    public function get_width():Float {
        return _width;
    }

    private var _height:Float = -1;
    public var height(get, set):Float;
    public function set_height(value:Float):Float {
        if (_height == value) {
            return value;
        }
        _height = value;
        return value;
    }

    public function get_height() {
        return _height;
    }

    private var _textWidth:Float = 0;
    public var textWidth(get, null):Float;
    private function get_textWidth():Float {
        return _textWidth;
    }

    private var _textHeight:Float = 0;
    public var textHeight(get, null):Float;
    private function get_textHeight():Float {
        return _textHeight;
    }

    public function applyStyle(style:Style) {
        
    }
}