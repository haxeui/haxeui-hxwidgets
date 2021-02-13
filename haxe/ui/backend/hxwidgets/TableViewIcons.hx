package haxe.ui.backend.hxwidgets;
import hx.widgets.Bitmap;

class TableViewIcons {
    private static var _map:Map<String, Bitmap> = new Map<String, Bitmap>();
    
    public static function get(id:String):Bitmap {
        if (_map.exists(id)) {
            return _map.get(id);
        }
        
        var bitmap = Bitmap.fromHaxeResource(id);
        _map.set(id, bitmap);
        return bitmap;
    }
    
    public static function findAndCompare(id:String, bmp:Bitmap):Bool {
        var entry = _map.get(id);
        if (entry == null && bmp != null) {
            return true;
        } else if (entry != null && bmp == null) {
            return true;
        } else if (entry == null && bmp == null) {
            return false;
        }
        return !bmp.equals(entry);
    }
}