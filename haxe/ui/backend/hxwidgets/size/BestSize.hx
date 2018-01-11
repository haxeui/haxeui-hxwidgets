package haxe.ui.backend.hxwidgets.size;

import haxe.ui.layouts.DelegateLayout.DelegateLayoutSize;
import hx.widgets.StaticText;

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
            var l:StaticText = cast component.window;
            l.wrap(Std.int(component.width));
        }
        
        return component.window.bestSize.height;
    }
}