package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.util.Variant;
import hx.widgets.ListView;

class ListViewSelectedIndex extends DataBehaviour {
    private override function validateData() {
        if (_component.window == null) {
            return;
        }
        
        var view:ListView = cast(_component.window, ListView);
        view.selectedIndex = _value;
        view.ensureVisible(_value);
    }
    
    public override function get():Variant {
        if (_component.window == null) {
            return -1;
        }
        
        var view:ListView = cast(_component.window, ListView);
        return view.selectedIndex;
        
    }
}