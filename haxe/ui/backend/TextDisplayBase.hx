package haxe.ui.backend;

import haxe.ui.assets.FontInfo;
import haxe.ui.core.Component;
import haxe.ui.core.TextDisplay.TextDisplayData;
import haxe.ui.styles.Style;

class TextDisplayBase {
    private var _displayData:TextDisplayData = new TextDisplayData();
    public var parentComponent:Component;
    
    private var _text:String;
    private var _textStyle:Style;
    
    private var _left:Float;
    private var _top:Float;
    private var _width:Float;
    private var _height:Float;
    private var _textWidth:Float;
    private var _textHeight:Float;
    
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