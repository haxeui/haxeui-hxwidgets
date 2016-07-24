package haxe.ui.backend.hxwidgets.size;

import haxe.ui.layouts.DelegateLayout.DelegateLayoutSize;
import hx.widgets.Notebook;

@:keep
class NotebookSize extends DelegateLayoutSize {
    private override function get_width():Float {
        return component.window.size.width;
    }

    private override function get_height():Float {
        return component.window.size.height;
    }

    private override function get_usableWidthModifier():Float {
        var m:Int = cast(component.window, Notebook).calcSizeFromPage().width;
        return m;
    }

    private override function get_usableHeightModifier():Float {
        var m:Int = cast(component.window, Notebook).calcSizeFromPage().height;
        return m;
    }
}