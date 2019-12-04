package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.Notebook;

@:keep
class NotebookRemovePage extends HxWidgetsBehaviour {
    public override function call(param:Any = null):Variant {
        if (_component.window == null) {
            return null;
        }
        
        var notebook:Notebook = cast(_component.window, Notebook);
        notebook.deletePage(param);
        
        return null;
    } 
}