package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import hx.widgets.Notebook;

class NotebookPageIndex extends DataBehaviour {
    public override function validateData() {
        if (_component.window == null) {
            return;
        }
        
        if (_value < 0) {
            return;
        }
        
        var notebook:Notebook = cast(_component.window, Notebook);
        notebook.selection = _value;
    }
    
    public override function get():Variant {
        if (_component.window == null) {
            return -1;
        }
        
        var notebook:Notebook = cast(_component.window, Notebook);
        return notebook.selection;
    }
}