package haxe.ui.backend.hxwidgets.creators;

import hx.widgets.Bitmap;

class StaticBitmapCreator extends Creator {
    public override function createConstructorParams(params:Array<Dynamic>):Array<Dynamic> {
        params.push(Bitmap.fromHaxeResource("styles/FF00FF-0.png"));
        return params;
    }
}