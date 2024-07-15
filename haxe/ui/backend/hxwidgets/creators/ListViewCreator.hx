package haxe.ui.backend.hxwidgets.creators;
import haxe.ui.containers.ListView;
import haxe.ui.constants.SelectionMode;
import hx.widgets.Defs;
import hx.widgets.styles.ListCtrlStyle;

class ListViewCreator extends Creator {
    private var _listView:ListView;
    
    public function new(listView:ListView) {
        super(listView);
        _listView = listView;
    }
    
    public override function createConstructorParams(params:Array<Dynamic>):Array<Dynamic> {
        var style = 0;
        if (_listView.selectionMode == SelectionMode.ONE_ITEM) style |= ListCtrlStyle.SINGLE_SEL;
        params.push(style);
        return params;
    }
}