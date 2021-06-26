package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.Notebook;

@:keep
class NotebookRemovePage extends HxWidgetsBehaviour {
    public override function call(param:Any = null):Variant {
        if (_component.window == null) {
            return null;
        }
        
        var index:Int = param;
        var child = _component.childComponents[index];
        _component.removeComponent(child);
        var notebook:Notebook = cast(_component.window, Notebook);
        notebook.deletePage(index);
        
        return null;
    } 
}