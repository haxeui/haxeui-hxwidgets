package haxe.ui.backend.hxwidgets.handlers;

import haxe.ui.components.DropDown;
import hx.widgets.Choice;
import hx.widgets.Event;
import hx.widgets.EventType;

class ChoiceHandler extends NativeHandler {
    public override function link() {
        _component.window.bind(EventType.CHOICE, __onChangeEvent);
    }
    
    public override function unlink() {
        _component.window.unbind(EventType.CHOICE, __onChangeEvent);
    }
    
    private function __onChangeEvent(event:Event) {
        var choice:Choice = cast(_component.window, Choice);
        var dropdown:DropDown = cast(_component, DropDown);
        dropdown.selectedIndex = choice.selection;
    }
}