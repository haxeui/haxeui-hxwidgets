package haxe.ui.backend.hxwidgets.creators;

import hx.widgets.Button;
import hx.widgets.Object;
import hx.widgets.ToggleButton;
import hx.widgets.Window;

class ButtonCreator extends Creator {
    private var _button:haxe.ui.components.Button;
    
    public function new(button:haxe.ui.components.Button) {
        super(button);
        _button = button;
    }
    
    public override function createWindow(parent:Object = null, style:Int = 0):Object {
        var b:Object = null;
        if (_button.toggle == true) {
            b = new ToggleButton(cast(parent, Window), null, style);
        } else {
            b = new Button(cast(parent, Window), null, style);
        }
        return b;
    }
}