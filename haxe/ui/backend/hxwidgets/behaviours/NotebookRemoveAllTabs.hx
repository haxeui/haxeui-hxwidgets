package haxe.ui.backend.hxwidgets.behaviours;
import haxe.ui.util.Variant;
import hx.widgets.Notebook;

@:keep
@:access(haxe.ui.core.Component)
class NotebookRemoveAllTabs extends HxWidgetsBehaviour {
    public override function run() {
        if (_component.window == null) {
            return;
        }
        
        var notebook:Notebook = cast(_component.window, Notebook);
        notebook.deleteAllPages();
    } 
}