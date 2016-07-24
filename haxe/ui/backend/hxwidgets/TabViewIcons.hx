package haxe.ui.backend.hxwidgets;

import haxe.ui.containers.TabView;
import hx.widgets.Bitmap;
import hx.widgets.ImageList;
import hx.widgets.Notebook;

class TabViewIcons {
    private static var _tabsToImageList:Map<TabView, ImageList> = new Map<TabView, ImageList>();
    private static var _imageListToIcon:Map<ImageList, Array<String>> = new Map<ImageList, Array<String>>();
    
    public static function getImageIndex(tabView:TabView, icon:String):Int {
        if (Toolkit.backendProperties.getPropBool('haxe.ui.hxwidgets.${Platform.name}.notebook.icons.hide', false) == true) {
            return -1;
        }
        
        if (icon == null) {
            return -1;
        }

        var index:Int = -1;
        var imageList:ImageList = _tabsToImageList.get(tabView);
        if (imageList != null) {
            var iconList:Array<String> = _imageListToIcon.get(imageList);
            if (iconList != null) {
               index = iconList.indexOf(icon); 
            }
        }
        
        if (index == -1) {
            index = addImage(tabView, icon);
        }
        
        return index;
    }
    
    public static function addImage(tabView:TabView, icon:String):Int {
        var imageList:ImageList = _tabsToImageList.get(tabView);
        if (imageList == null) {
            imageList = new ImageList(16, 16); // TODO: get real size here
            _tabsToImageList.set(tabView, imageList);
            var notebook:Notebook =  cast tabView.window;
            notebook.imageList = imageList;
        }
        
        var iconList:Array<String> = _imageListToIcon.get(imageList);
        if (iconList == null) {
            iconList = new Array<String>();
            _imageListToIcon.set(imageList, iconList);
        }
        imageList.add(Bitmap.fromHaxeResource(icon));
        iconList.push(icon);
        
        return iconList.indexOf(icon);
    }
}