package haxe.ui.backend.hxwidgets;
import hx.widgets.Bitmap;
import hx.widgets.ImageList;
import hx.widgets.Notebook;
import hx.widgets.Window;

class IconMap<T:ComponentImpl> {
    private var _objectsToImageList:Map<T, ImageList> = new Map<T, ImageList>();
    private var _imageListToIcon:Map<ImageList, Array<String>> = new Map<ImageList, Array<String>>();
    
    public function new() {
    }
    
    public function getImageIndex(object:T, icon:String, setCallback:ImageList->Void):Int {
        if (icon == null) {
            return -1;
        }

        var index:Int = -1;
        var imageList:ImageList = _objectsToImageList.get(object);
        if (imageList != null) {
            var iconList:Array<String> = _imageListToIcon.get(imageList);
            if (iconList != null) {
               index = iconList.indexOf(icon);
            }
        }

        if (index == -1) {
            index = addImage(object, icon, setCallback);
        }

        return index;
    }

    public function addImage(object:T, icon:String, setCallback:ImageList->Void):Int {
        var imageList:ImageList = _objectsToImageList.get(object);
        if (imageList == null) {
            imageList = new ImageList(16, 16); // TODO: get real size here
            _objectsToImageList.set(object, imageList);
            setCallback(imageList);
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