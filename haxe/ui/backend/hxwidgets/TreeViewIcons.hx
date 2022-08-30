package haxe.ui.backend.hxwidgets;

import haxe.ui.containers.TreeView;

class TreeViewIcons {
    private static var _map:IconMap<TreeView> = new IconMap<TreeView>();
    
    public static function get(treeView:TreeView, icon:String):Int {
        return _map.getImageIndex(treeView, icon, function(imageList) {
            var window:hx.widgets.DataViewTreeCtrl = cast treeView.window;
            window.imageList = imageList;
        });
    }
}