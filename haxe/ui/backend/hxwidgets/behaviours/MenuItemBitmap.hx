package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import hx.widgets.Bitmap;
import hx.widgets.MenuItem;

class MenuItemBitmap extends DataBehaviour {
    public override function validateData() {
        var bmp = Bitmap.fromHaxeResource(_value);
        var item = cast(_component.object, MenuItem);
        item.bitmap = bmp;
    }

}