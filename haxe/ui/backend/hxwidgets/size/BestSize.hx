package haxe.ui.backend.hxwidgets.size;

import haxe.ui.layouts.DelegateLayout.DelegateLayoutSize;
import hx.widgets.Dialog;

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
        return component.window.bestSize.height;
    }
}