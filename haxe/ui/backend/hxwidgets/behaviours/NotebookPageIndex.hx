package haxe.ui.backend.hxwidgets.behaviours;
import haxe.ui.behaviours.DataBehaviour;
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
}