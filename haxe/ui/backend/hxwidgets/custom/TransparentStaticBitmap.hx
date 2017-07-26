package haxe.ui.backend.hxwidgets.custom;

import hx.widgets.Bitmap;
import hx.widgets.Event;
import hx.widgets.EventType;
import hx.widgets.StaticBitmap;
import hx.widgets.Window;

class TransparentStaticBitmap extends StaticBitmap {
    private var _hasDown:Bool = true;
    private var _hasUp:Bool = true;
    
    public function new(parent:Window, bitmap:Bitmap, id:Int = -1) {
        super(parent, bitmap, id);
        super.bind(EventType.LEFT_DOWN, doNothing);
        super.bind(EventType.LEFT_UP, doNothing);
    }
    
    public override function bind(event:Int, fn:Event->Void, id:Int = -1) {
        if (event == EventType.LEFT_DOWN && _hasDown == true) {
            super.unbind(EventType.LEFT_DOWN, doNothing);
            _hasDown = false;
        }
        if (event == EventType.LEFT_UP && _hasUp == true) {
            super.unbind(EventType.LEFT_UP, doNothing);
            _hasUp = false;
        }
        
        super.bind(event, fn, id);
    }
    
    private function doNothing(e) {
        
    }
}