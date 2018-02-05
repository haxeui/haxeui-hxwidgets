package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.Notebook;

@:keep
class NotebookRemoveAllPages extends HxWidgetsBehaviour {
    public override function run(param:Variant = null) {
        if (_component.window == null) {
            return;
        }
        
        var notebook:Notebook = cast(_component.window, Notebook);
        notebook.deleteAllPages();
    } 
}