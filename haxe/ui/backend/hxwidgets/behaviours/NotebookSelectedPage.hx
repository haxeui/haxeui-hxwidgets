package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.Behaviour;
import haxe.ui.util.Variant;
import hx.widgets.Notebook;

class NotebookSelectedPage extends Behaviour {
    public override function get():Variant {
        var notebook:Notebook = cast(_component.window, Notebook);
        var selectedComponent = _component.childComponents[notebook.selection];
        return selectedComponent;
    }    

    public override function set(value:Variant) {
        if (_component.window == null) {
            return;
        }

        var notebook:Notebook = cast(_component.window, Notebook);
        if (value == null || value.isNull) {
            return;
        }

        var index = _component.childComponents.indexOf(value);
        if (index != -1) {
            notebook.selection = index;
        }
    }
}