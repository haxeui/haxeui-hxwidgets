package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.util.Variant;
import hx.widgets.ListView;

class ListViewSelectedIndex extends HxWidgetsBehaviour {
    public override function get():Variant {
        if (_component.window == null) {
            return -1;
        }
        
        var view:ListView = cast(_component.window, ListView);
        if (view.selectedItemCount <= 0) {
            return -1;
        }
        
        return view.selectedIndexes[0];
    }
}