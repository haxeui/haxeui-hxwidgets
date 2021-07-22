package haxe.ui.backend.hxwidgets.custom;

import haxe.ui.constants.ScaleMode;
import hx.widgets.Bitmap;
import hx.widgets.Event;
import hx.widgets.EventType;
import hx.widgets.StaticBitmap;
import hx.widgets.Window;

class TransparentStaticBitmap extends StaticBitmap {
    private var _hasDown:Bool = true;
    private var _hasUp:Bool = true;
    
    public var scaleMode:ScaleMode = ScaleMode.FILL;
    
    public function new(parent:Window, bitmap:Bitmap, id:Int = -1) {
        super(parent, bitmap, id);
        super.bind(EventType.LEFT_DOWN, doNothing);
        super.bind(EventType.LEFT_UP, doNothing);
        super.bind(EventType.SIZE, onSize);
    }
    
    private var _scaleMode:ScaleMode = ScaleMode.FILL;
    private function get_scaledMode():ScaleMode {
        return _scaleMode;
    }
    private function set_scaleMode(value:ScaleMode):ScaleMode {
        if (_scaleMode == value) {
            return value; 
        }
        
        _scaleMode = value;
        onSize(null);
        
        return value;
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
    
    private function onSize(_) {
        var s = this.size;
        var cx = this.size.width;
        var cy = this.size.height;
        var bmp = this.bitmap;
        var bmpCX = bmp.width;
        var bmpCY = bmp.height;
        
        if (cx != bmpCX || cy != bmpCY) {
            
            var scaleW:Float = cx / bmpCX;
            var scaleH:Float = cy / bmpCY;
            
            if (scaleMode != ScaleMode.FILL) {
                var scale:Float;
                switch (scaleMode) {
                    case ScaleMode.FIT_INSIDE:
                        scale = (scaleW < scaleH) ? scaleW : scaleH;
                    case ScaleMode.FIT_OUTSIDE:
                        scale = (scaleW > scaleH) ? scaleW : scaleH;
                    case ScaleMode.FIT_WIDTH:
                        scale = scaleW;
                    case ScaleMode.FIT_HEIGHT:
                        scale = scaleH;
                    default:    //ScaleMode.NONE
                        scale = 1;
                }
                
                scaleW = scale;
                scaleH = scale;
            }
            
            var image = bmp.convertToImage();
            var scaled = image.scale(Std.int(bmpCX * scaleW), Std.int(bmpCY * scaleH));
            this.bitmap = new Bitmap(scaled);
           
            bmp.destroy();
            image.destroy();
            scaled.destroy();
        }
    }
}