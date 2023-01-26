package haxe.ui.backend.hxwidgets.handlers;

import haxe.ui.components.TextField;
import haxe.ui.styles.Style;
import haxe.ui.events.UIEvent;
import hx.widgets.styles.TextCtrlStyle;
import hx.widgets.TextCtrl;
import hx.widgets.EventType;

class TextCtrlHandler extends NativeHandler {
	public override function link() {
        if ((_component is TextField)) {
            _component.window.bind(EventType.TEXT_ENTER, onEnterEvent);
        }
    }

    public override function unlink() {
        if ((_component is TextField)) {
            _component.window.unbind(EventType.TEXT_ENTER, onEnterEvent);
        }
    }
    
    private function onEnterEvent(e) {
    	_component.dispatch(new UIEvent(UIEvent.USER_SUBMIT));
    }
    
    public override function applyStyle(style:Style):Bool {
        if (style.textAlign != null) {
            var alignStyle:Int = switch(style.textAlign) {
                case "center": TextCtrlStyle.CENTRE;
                case "right": TextCtrlStyle.RIGHT;
                default: TextCtrlStyle.LEFT;
            }
            window.windowStyle = (window.windowStyle & ~(TextCtrlStyle.LEFT | TextCtrlStyle.RIGHT | TextCtrlStyle.CENTRE))   //Remove old align
                                | alignStyle;
        }
        return true;
    }
}