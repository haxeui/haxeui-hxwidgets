package haxe.ui.backend.hxwidgets;

import haxe.ui.containers.TabView2;
import hx.widgets.Bitmap;
import hx.widgets.ImageList;
import hx.widgets.Notebook;

class TabViewIcons {
    private static var _map:IconMap<TabView2> = new IconMap<TabView2>();
    
    public static function get(tabView:TabView2, icon:String):Int {
        return _map.getImageIndex(tabView, icon, function(imageList) {
            var window:hx.widgets.Notebook = cast tabView.window;
            window.imageList = imageList;
        });
    }
}