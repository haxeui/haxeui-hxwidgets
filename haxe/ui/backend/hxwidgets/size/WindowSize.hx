package haxe.ui.backend.hxwidgets.size;

import haxe.ui.core.Platform;
import haxe.ui.layouts.DelegateLayout.DelegateLayoutSize;
import hx.widgets.ScrolledWindow;

@:keep
@:access(haxe.ui.core.Component)
class WindowSize extends DelegateLayoutSize {
    private override function get_width():Float {
        return component.window.size.width;
    }

    private override function get_height():Float {
        return component.window.size.height;
    }

    private override function get_usableWidthModifier():Float {
        #if !haxeui_hxwidgets_ignorescroll_sizes

        if ((component.window is ScrolledWindow) && component.childComponents.length > 0) {
            if (component.childComponents[0].componentHeight > component.componentHeight) {
                return Platform.vscrollWidth;
            }
        }

        #end

        return 0;
    }

    private override function get_usableHeightModifier():Float {
        #if !haxeui_hxwidgets_ignorescroll_sizes

        if ((component.window is ScrolledWindow) && component.childComponents.length > 0) {
            if (component.childComponents[0].componentWidth > component.componentWidth) {
                return Platform.hscrollHeight;
            }
        }

        #end
        
        return 0;
    }
}