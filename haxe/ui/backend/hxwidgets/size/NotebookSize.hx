package haxe.ui.backend.hxwidgets.size;

import haxe.ui.layouts.DelegateLayout.DelegateLayoutSize;
import hx.widgets.Notebook;

@:keep
class NotebookSize extends DelegateLayoutSize {
    private override function get_width():Float {
        return component.window.bestSize.width;
    }

    private override function get_height():Float {
        var h = component.window.bestSize.height;
        if (Platform.isWindows) { // windows lower padding workaround
            h += 4;
        }
        return h;
    }

    private override function get_usableWidthModifier():Float {
        if (component == null || component.window == null) {
            return 0;
        }
        var m:Int = cast(component.window, Notebook).calcSizeFromPage().width;
        return m;
    }

    private override function get_usableHeightModifier():Float {
        if (component == null || component.window == null) {
            return 0;
        }
        var m:Int = cast(component.window, Notebook).calcSizeFromPage().height;
        return m;
    }
}