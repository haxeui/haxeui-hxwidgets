package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import hx.widgets.ListView;

class ListViewSelectedIndices extends DataBehaviour {
    
    private override function validateData() {
        if (_component.window == null) {
            return;
        }

        if (!_value.isArray) {
            return;
        }
        
        var view:ListView = cast(_component.window, ListView);
        view.selectedIndexes = _value;

        for (i in (_value:Array<Int>)) {
            view.ensureVisible(i);
        }
    }
    
    public override function get():Variant {
        if (_component.window == null) {
            return -1;
        }
        
        var view:ListView = cast(_component.window, ListView);
        return view.selectedIndexes;
        
    }
}