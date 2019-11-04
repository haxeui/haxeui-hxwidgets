package haxe.ui.backend.hxwidgets.custom;

import hx.widgets.Event;
import hx.widgets.EventType;
import hx.widgets.ListView;
import hx.widgets.Window;
import hx.widgets.styles.ListCtrlStyle;

class SimpleListView extends ListView {
    public function new(parent:Window, style:Int = 0, id:Int = -1) {
        super(parent, ListCtrlStyle.REPORT | ListCtrlStyle.NO_HEADER | ListCtrlStyle.SINGLE_SEL | style, id);
        appendColumn("");
        bind(EventType.SIZE, onResized);
    }
    
    private function onResized(event:Event) {
        setColumnWidth(0, this.clientSize.width + 1);
    }
    
    public var selectedIndex(get, null):Int;
    private function get_selectedIndex():Int {
        var indexes = selectedIndexes;
        if (indexes.length == 0) {
            return -1;
        }
        return indexes[0];
    }
}