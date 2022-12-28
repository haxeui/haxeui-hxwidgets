package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.data.DataSource;
import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.components.DropDown;
import haxe.ui.containers.ListView;
import haxe.ui.core.IDataComponent;
import haxe.ui.util.Variant;

class DataComponentSelectedItem extends DataBehaviour {
    private var _cachedValue:Dynamic = null; // might need revision here for core behaviours, since Variant cant actually hold a TObject

    public override function getDynamic():Dynamic {
        if ((_component is IDataComponent) == false) {
            return false;
        }

        var dataComponent:IDataComponent = cast(_component, IDataComponent);
        var ds = dataComponent.dataSource;
        var selectedItem = null;

        if ((_component is DropDown)) {
            var dropDown = cast(_component, DropDown);
            if (dropDown.selectedIndex > -1) {
                selectedItem = ds.get(dropDown.selectedIndex);
            } else if (_cachedValue != null) {
                selectedItem = _cachedValue;
            }
        } else if ((_component is ListView)) {
            var listview = cast(_component, ListView);
            if (listview.selectedIndex > -1) {
                selectedItem = ds.get(listview.selectedIndex);
            } else if (_cachedValue != null) {
                selectedItem = _cachedValue;
            }
        }
        
        return selectedItem;
    }

    public override function setDynamic(value:Dynamic) {
        _cachedValue = value;
        var dataComponent:IDataComponent = cast(_component, IDataComponent);
        var ds = dataComponent.dataSource;
        var selectedIndex = findIndexOfItem(value, ds);
        if ((_component is DropDown)) {
            var dropDown = cast(_component, DropDown).selectedIndex = selectedIndex;
        } else if ((_component is ListView)) {
            var listview = cast(_component, ListView).selectedIndex = selectedIndex;
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