package haxe.ui.backend;

import haxe.ui.assets.FontInfo;
import haxe.ui.core.Component;
import haxe.ui.styles.Style;

class TextDisplayBase {
    public var parentComponent:Component;
    
    private var _text:String;
    private var _textStyle:Style;
    
    private var _left:Float;
    private var _top:Float;
    private var _width:Float;
    private var _height:Float;
    private var _textWidth:Float;
    private var _textHeight:Float;
    
    private var _multiline:Bool;
    private var _wordWrap:Bool;
    
    private var _fontInfo:FontInfo;
    
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
    
    private function measureText() {
        
    }
}