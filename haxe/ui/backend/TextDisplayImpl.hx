package haxe.ui.backend;

import haxe.ui.assets.FontInfo;
import haxe.ui.core.Component;
import haxe.ui.core.TextDisplay.TextDisplayData;
import haxe.ui.styles.Style;

class TextDisplayImpl extends TextBase {

    private override function get_selectionStartIndex():Int {
    	var textCtrl:hx.widgets.TextCtrl = cast(this.parentComponent.window, hx.widgets.TextCtrl);
        return textCtrl.selection.start;
    }
    
    private override function set_selectionStartIndex(value:Int):Int {
    	var textCtrl:hx.widgets.TextCtrl = cast(this.parentComponent.window, hx.widgets.TextCtrl);
    	var endIndex = selectionEndIndex < value ? value : selectionEndIndex; // otherwise hxWigets changes start to end
    	textCtrl.selection = {start: value, end: endIndex};
        return value;
    }
    
    
    private override function get_selectionEndIndex():Int {
        var textCtrl:hx.widgets.TextCtrl = cast(this.parentComponent.window, hx.widgets.TextCtrl);
        return textCtrl.selection.end;
    }
    
    private override function set_selectionEndIndex(value:Int):Int {
        var textCtrl:hx.widgets.TextCtrl = cast(this.parentComponent.window, hx.widgets.TextCtrl);
    	textCtrl.selection = {start: selectionStartIndex, end: value};
        return value;
    }
}
