package haxe.ui.backend.hxwidgets.creators;

import haxe.ui.core.Component;
import hx.widgets.Object;

class Creator {
    private var _component:Component;
    
    public function new(component:Component) {
        _component = component;
    }
    
    public function createStyle(style:Int):Int {
        return style;
    }
    
    public function createConstructorParams(params:Array<Dynamic>):Array<Dynamic> {
        return params;
    }
    
    public function createWindow(parent:Object = null, style:Int = 0):Object {
        return null;
    }
}