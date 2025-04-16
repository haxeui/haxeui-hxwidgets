package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.data.DataSource;
import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.components.DropDown;
import haxe.ui.containers.ListView;
import haxe.ui.core.IDataComponent;
import haxe.ui.util.Variant;

class DataComponentSelectedItems extends DataBehaviour {

    public override function get():Variant {
        if ((_component is IDataComponent) == false) {
            return false;
        }

        var dataComponent:IDataComponent = cast(_component, IDataComponent);
        var ds = dataComponent.dataSource;
        var selectedItems:Array<Dynamic> = [];

        if ((_component is ListView)) {
            var listview = cast(_component, ListView);
            for (i in listview.selectedIndices) {
                selectedItems.push(ds.get(i));
            }
        }
        
        return selectedItems;
    }

    public override function set(value:Variant):Void {
        _value = value;
        var dataComponent:IDataComponent = cast(_component, IDataComponent);
        var selectedIndices = [];

        var ds = dataComponent.dataSource;
        var values:Array<Dynamic> = value;
        for (item in values) {
            var selectedIndex = findIndexOfItem(value, ds);
            selectedIndices.push(selectedIndex);
        }
       
        if ((_component is ListView)) {
            var listview = cast(_component, ListView).selectedIndices = selectedIndices;
        }
    }

    private function findIndexOfItem(value:Dynamic, ds:DataSource<Dynamic>) {
        var n = -1;

        var text = valueToString(value);
        if (text == null) {
            return -1;
        }

        for (i in 0...ds.size) {
            if (text == valueToString(ds.get(i))) {
                n = i;
                break;
            }
        }

        return n;
    }

    private function valueToString(value:Dynamic):String {
        var text = null;
        if (Type.typeof(value) == TObject) {
            text = value.text;
            if (text == null) {
                text = value.value;
            }
        } else {
            text = Std.string(value);
        }
        return text;
    }
}