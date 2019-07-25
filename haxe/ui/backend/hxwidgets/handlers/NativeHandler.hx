package haxe.ui.backend.hxwidgets.handlers;

import haxe.ui.core.Component;
import haxe.ui.styles.Style;
import hx.widgets.Window;

class NativeHandler {
    private var _component:Component;
    public function new(component:Component) {
        _component = component;
    }
    
    public function link() {
    }
    
    public function unlink() {
    }
    
    public function applyStyle(style:Style):Bool {
        return false;
    }
    
    public var window(get, null):Window;
    private function get_window():Window {
        return _component.window;
    }
}