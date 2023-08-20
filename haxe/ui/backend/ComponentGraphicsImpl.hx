package haxe.ui.backend;

import haxe.io.Bytes;
import haxe.ui.core.Component;
import haxe.ui.events.UIEvent;
import hx.widgets.Bitmap;
import hx.widgets.Bitmap;
import hx.widgets.EventType;
import hx.widgets.Image;
import hx.widgets.PaintDC;
import hx.widgets.Pen;

class ComponentGraphicsImpl extends ComponentGraphicsBase {


    public function new(c:Component) {
        super(c);
        c.registerEvent(UIEvent.READY, function f(_) {
            _component.window.bind(EventType.PAINT, onWindowPaint);
        });
    }

    private function onWindowPaint(e) {

        e.stopPropagation();
        
        var dc = new PaintDC(_component.window);

        var penPosX = 0;
        var penPosY = 0;

        var penColor = 0;
        var penThickness = 0;

        for (c in _drawCommands) {
            switch (c) {
                case Clear:
                    dc.clear();
                case Circle(x, y, radius):
                    dc.drawCircle(Std.int(x), Std.int(y), Std.int(radius));
                case StrokeStyle(color, thickness, alpha):
                    penColor = Std.int(color);
                    penThickness = Std.int(thickness);
                    dc.pen = new Pen(penColor, penThickness);
                    
                case MoveTo(x, y):
                    penPosX = Std.int(x);
                    penPosY = Std.int(y);
                case SetPixel(x, y, color):
                    if (color != penColor) {
                        dc.pen = new Pen(Std.int(color));
                    }      
                    dc.drawPoint(Std.int(x),Std.int(y));
                    if (color != penColor) {
                        dc.pen = new Pen(penColor, penThickness);
                    }
                case SetPixels(pixels):
                    var img =  new Image( Std.int(_component.actualComponentWidth), Std.int(_component.actualComponentHeight), true);
                    img.imageData.copyRGBA(pixels);
                    var bmp = new Bitmap(img);
                    dc.drawBitmap(bmp);
                case LineTo(x, y):
                    dc.drawLine(penPosX, penPosY, Std.int(x), Std.int(y));
                case Rectangle(x, y, width, height):
                    dc.drawRectangle(Std.int(x), Std.int(y), Std.int(width), Std.int(height));
                case CurveTo(controlX, controlY, anchorX, anchorY):
                    //gp.addQuadCurveToPoint(controlX, controlY, anchorX, anchorY);
                case CubicCurveTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY):
                    //gp.addCurveToPoint(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
                case _:


            }
        }
        dc.destroy();
    }
}