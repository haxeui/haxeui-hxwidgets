package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.Behaviour;
import haxe.ui.util.Variant;

class NotebookGetPage extends Behaviour {
    public override function call(param:Any = null):Variant {
        if (_component.window == null) {
            return null;
        }
        
        var index:Int = param;
        var page = _component.childComponents[index];
        
        return page;
    } 
}