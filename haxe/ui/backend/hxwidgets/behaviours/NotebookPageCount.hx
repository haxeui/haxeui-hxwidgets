package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.Notebook;

class NotebookPageCount extends HxWidgetsBehaviour {
    public override function get():Variant {
        if (_component.window == null) {
            return -1;
        }
        
        var view:Notebook = cast(_component.window, Notebook);
        return view.pageCount;
    }
}