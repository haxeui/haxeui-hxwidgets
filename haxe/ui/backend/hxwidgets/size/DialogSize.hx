package haxe.ui.backend.hxwidgets.size;

import haxe.ui.layouts.DelegateLayout.DelegateLayoutSize;
import hx.widgets.Notebook;
import hx.widgets.SystemMetric;
import hx.widgets.SystemSettings;

@:keep
class DialogSize extends DelegateLayoutSize {
    private override function get_width():Float {
        return component.window.bestSize.width;
    }

    private override function get_height():Float {
        return component.window.bestSize.height;
    }

    private override function get_usableWidthModifier():Float {
        var m:Int = 6;
        return m;
    }

    private override function get_usableHeightModifier():Float {
        var m:Int = SystemSettings.getMetric(SystemMetric.CAPTION_Y);
        return m;
    }
}