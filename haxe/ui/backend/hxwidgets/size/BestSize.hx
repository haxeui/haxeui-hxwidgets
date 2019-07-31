package haxe.ui.backend.hxwidgets.size;

import haxe.ui.layouts.DelegateLayout.DelegateLayoutSize;
import hx.widgets.HardBreakWrapper;
import hx.widgets.StaticText;

@:access(haxe.ui.core.Component)
class BestSize extends DelegateLayoutSize {
    private override function get_width():Float {
        if (component.window == null) {
            return 0;
        }
        return component.window.bestSize.width;
    }

    private override function get_height():Float {
        if (component.window == null) {
            return 0;
        }
        
        if (Std.is(component.window, StaticText) && component.autoWidth == false && component.width > 0) {
            var label = component.get("originalLabel");
            if (label != null) { // https://forums.wxwidgets.org/viewtopic.php?t=26973
                var l:StaticText = cast component.window;
                var h:HardBreakWrapper = new HardBreakWrapper(l, label, Std.int(component.width));
                l.label = h.wrapped;
            }
        }
        
        return component.window.bestSize.height;
    }
}