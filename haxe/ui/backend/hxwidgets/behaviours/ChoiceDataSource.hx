package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.locale.LocaleEvent;
import haxe.ui.locale.LocaleManager;
import haxe.ui.events.UIEvent;
import haxe.ui.behaviours.DataBehaviour;
import haxe.ui.components.DropDown;
import haxe.ui.data.ArrayDataSource;
import haxe.ui.data.DataSource;
import haxe.ui.util.Variant;
import hx.widgets.Choice;

@:access(haxe.ui.core.Component)
class ChoiceDataSource extends DataBehaviour {

    public function new(component:haxe.ui.core.Component) {
        super(component);
        LocaleManager.instance.registerEvent(LocaleEvent.LOCALE_CHANGED, function (e) {
            changeLang();
        });
    }
    public override function get():Variant {
        if (_value == null || _value.isNull) {
            _value = new ArrayDataSource<Dynamic>();
            set(_value);
        }
        return _value;
    }
    
    public override function set(value:Variant) {
        super.set(value);
        if (value != null && value.isNull == false) {
            var ds:DataSource<Dynamic> = value;
            ds.onChange = function() {
                validateData();
            }
        }
    }

    public function changeLang() {
        if (_component.window == null) {
            return;
        }

        var choice:Choice = cast(_component.window, Choice);
        var oldSelection = choice.selection;
        choice.clear();
        
        if (_value.isNull) {
            return;
        }
        
        var ds:DataSource<Dynamic> = _value;
        for (n in 0...ds.size) {
            var item = ds.get(n);
            if (item.text != null) {
                choice.append(LocaleManager.instance.stringToTranslation(item.text));
            } else {
                choice.append(Std.string(item));
            }
        }

        var dropDown:DropDown = cast(_component, DropDown);
        choice.selection = oldSelection;
        if (dropDown.text != null) {
            choice.selectedString = dropDown.text;
        }
    }

    public override function validateData() {
        if (_component.window == null) {
            return;
        }

        var choice:Choice = cast(_component.window, Choice);
        choice.clear();
        
        if (_value.isNull) {
            return;
        }
        
        var ds:DataSource<Dynamic> = _value;
        for (n in 0...ds.size) {
            var item = ds.get(n);
            if (item.text != null) {
                choice.append(LocaleManager.instance.stringToTranslation(item.text));
            } else {
                choice.append(Std.string(item));
            }
        }

        var dropDown:DropDown = cast(_component, DropDown);
        choice.selection = dropDown.selectedIndex;
        if (dropDown.text != null) {
            choice.selectedString = dropDown.text;
        }
        if (_component.get("hasSelection") == true) {
            choice.selection = 0;
            dropDown.dispatch(new UIEvent(UIEvent.CHANGE));
        }
    }
}