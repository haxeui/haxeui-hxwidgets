package haxe.ui.backend;

import hx.widgets.Pen;
import hx.widgets.Pen;
import hx.widgets.Pen;
import hx.widgets.Bitmap;
import haxe.io.Bytes;
import haxe.ui.core.Component;
import haxe.ui.events.UIEvent;
import haxe.ui.graphics.DrawCommand;
import hx.widgets.Bitmap;
import hx.widgets.Bitmap;
import hx.widgets.EventType;
import hx.widgets.Image;
import hx.widgets.PaintDC;
import hx.widgets.GraphicsContext;
import hx.widgets.Pen;

class ComponentGraphicsImpl extends ComponentGraphicsBase {
    public function new(c:Component) {
        super(c);
        c.registerEvent(UIEvent.READY, function f(_) {
            _component.window.bind(EventType.PAINT, onWindowPaint);
        });
    }

    private var _requiresRefresh:Bool = false;
    private override function addDrawCommand(command:DrawCommand) {
        if (!_requiresRefresh) {
            if (_component.window != null) {
                _component.window.refresh();
            }
            _requiresRefresh = true;
        }
        super.addDrawCommand(command);
    }

    private var _currentPixels:Bytes;
    private var _currentImage:Image;
    private var _currentPen:Pen = null;
    private var _currentPenColor = 0x000000;
    private var _currentPenThickness:Int = 1;

    private function onWindowPaint(e) {
        var dc = new PaintDC(_component.window);
        var gc = new GraphicsContext(_component.window);

        var penPosX = 0;
        var penPosY = 0;

        if (_currentPen != null) {
            _currentPen.destroy();
        }
        _currentPen = new Pen(_currentPenColor, _currentPenThickness);
        dc.pen = _currentPen;
        gc.pen = _currentPen;

        for (c in _drawCommands) {
            switch (c) {
                case Clear:
                    dc.clear();
                case Circle(x, y, radius):
                    dc.drawCircle(Std.int(x), Std.int(y), Std.int(radius));
                case StrokeStyle(color, thickness, alpha):
                    if (color != _currentPenColor || thickness != _currentPenThickness) {
                        _currentPenColor = color;
                        _currentPenThickness = Std.int(thickness);

                        if (_currentPen != null) {
                            _currentPen.destroy();
                        }
                        _currentPen = new Pen(_currentPenColor, _currentPenThickness);
                        dc.pen = _currentPen;
                        gc.pen = _currentPen;
                    }

                case MoveTo(x, y):
                    penPosX = Std.int(x);
                    penPosY = Std.int(y);
                case SetPixel(x, y, color): // TODO: do we care a SetPixel? If we do, we need to create a "pixelPen" and use that, and then after select the old pen back into the device contexts... but... 
                case SetPixels(pixels):
                    if (pixels != _currentPixels) {
                        _currentPixels = pixels;
                        if (_currentImage != null) {
                            _currentImage.destroy();
                        }

                        _currentImage = new Image(Std.int(_component.actualComponentWidth), Std.int(_component.actualComponentHeight), true);
                    }

                    _currentImage.imageData.copyRGBA(_currentPixels);
                    // There is no way to update an existing bitmap, you have to create a new one.
                    var bmp = new Bitmap(_currentImage);
                    dc.drawBitmap(bmp);
                    bmp.destroy();
                case LineTo(x, y):
                    dc.drawLine(penPosX, penPosY, Std.int(x), Std.int(y));
                case Rectangle(x, y, width, height):
                    dc.drawRectangle(Std.int(x), Std.int(y), Std.int(width), Std.int(height));
                case CurveTo(controlX, controlY, anchorX, anchorY):
                    var path = gc.createPath();
                    path.moveToPoint(penPosX, penPosY);
                    path.addQuadCurveToPoint(controlX, controlY, anchorX, anchorY);
                    gc.strokePath(path);
                case CubicCurveTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY):
                    var path = gc.createPath();
                    path.moveToPoint(penPosX, penPosY);
                    path.addCurveToPoint(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
                    gc.strokePath(path);
                case _:
            }
        }
        dc.destroy();
        gc.destroy();

        e.stopPropagation();

        _requiresRefresh = false;
    }
}
