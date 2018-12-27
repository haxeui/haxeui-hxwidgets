package haxe.ui.backend.hxwidgets;

import haxe.ui.backend.hxwidgets.custom.SimpleListView;
import haxe.ui.containers.ListView;

class ListViewIcons {
    private static var _map:IconMap<ListView> = new IconMap<ListView>();
    
    public static function get(listView:ListView, icon:String, large:Bool = false):Int {
        return _map.getImageIndex(listView, icon, function(imageList) {
            var window:hx.widgets.ListView = cast listView.window;
            if (large == true) {
                window.largeImageList = imageList;
            } else {
                window.smallImageList = imageList;
            }
        });
    }
}