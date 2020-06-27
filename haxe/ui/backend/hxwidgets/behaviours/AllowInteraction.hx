package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import hx.widgets.EventType;

class AllowInteraction extends DataBehaviour {
    public override function validateData() {
        if (_component.window == null) {
            return;
        }
        
        trace("HERE!" + _value);
        if (_value == true) {
            registerEvents();
        } else {
            unregisterEvents();
        }
    }
    
    private var _hasEvents:Bool = false;
    private function registerEvents() {
        if (_hasEvents == false) {
            _hasEvents = true;
            _component.window.bind(EventType.ENTER_WINDOW, onEnterWindow);
            _component.window.bind(EventType.LEAVE_WINDOW, onLeaveWindow);
            _component.window.bind(EventType.LEFT_DOWN, onLeftDown);
            _component.window.bind(EventType.LEFT_UP, onLeftUp);
        }
    }
    
    private function unregisterEvents() {
        if (_hasEvents == true) {
            _hasEvents = false;
            _component.window.unbind(EventType.ENTER_WINDOW, onEnterWindow);
            _component.window.unbind(EventType.LEAVE_WINDOW, onLeaveWindow);
            _component.window.unbind(EventType.LEFT_DOWN, onLeftDown);
            _component.window.unbind(EventType.LEFT_UP, onLeftUp);
        }
    }
    
    private function onLeftDown(e) {
        _component.addClass(":down");
    }
    
    private function onLeftUp(e) {
        _component.removeClass(":down");
    }
    
    private function onEnterWindow(e) {
        _component.addClass(":hover");
    }
    
    private function onLeaveWindow(e) {
        _component.removeClass(":hover");
    }
}