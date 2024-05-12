package haxe.ui.backend;

import hx.widgets.StockBrushes;
import hx.widgets.Brush;
import hx.widgets.GraphicsPath;
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
    private var _currentPenAlpha = 1.;
    private var _currentBrushColor = null;
    private var _currentBrushAlpha = 1.;
    private var _generalBrushColor = null;
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
        dc.brush = StockBrushes.BRUSH_TRANSPARENT;
        gc.brush = StockBrushes.BRUSH_TRANSPARENT;

        var currentPath:GraphicsPath = null;
        

        for (c in _drawCommands) {
            switch (c) {
                case Clear:
                    dc.clear();
                case Circle(x, y, radius):
                    dc.drawCircle(Std.int(x), Std.int(y), Std.int(radius));
                case StrokeStyle(color, thickness, alpha):
                    if (color != _currentPenColor || thickness != _currentPenThickness || alpha != _currentPenAlpha) {
                        _currentPenColor = color;
                        _currentPenThickness = Std.int(thickness);
                        _currentPenAlpha = alpha;

                        if (_currentPen != null) {
                            _currentPen.destroy();
                        }
                        _currentPen = new Pen(_currentPenColor, _currentPenThickness);
                        dc.pen = _currentPen;
                        gc.pen = _currentPen;
                    }
                case FillStyle(color, alpha):
                    if (color != _currentBrushColor || alpha != _currentBrushAlpha) {
                        _currentBrushColor = color;
                        _currentBrushAlpha = alpha;
                        if (color == null || alpha == 0) {
                            dc.brush = StockBrushes.BRUSH_TRANSPARENT;
                            gc.brush = StockBrushes.BRUSH_TRANSPARENT;
                        } else {
                            dc.brush = new Brush(_currentBrushColor);
                            gc.brush = new Brush(_currentBrushColor);
                        }
                    }
                    if (currentPath == null) _generalBrushColor = color;
                case MoveTo(x, y):
                    var path = currentPath;
                    if (path == null) {
                        penPosX = Std.int(x);
                        penPosY = Std.int(y);
                    } else {
                        path.moveToPoint(x,y);
                    }
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
                    var path = currentPath;
                    if (path == null) {
                        dc.drawLine(penPosX, penPosY, Std.int(x), Std.int(y));
                        penPosX = Std.int(x);
                        penPosY = Std.int(y);
                    } else {
                        path.addLineToPoint(Std.int(x), Std.int(y));
                    }
                    
                case Rectangle(x, y, width, height):
                    dc.drawRectangle(Std.int(x), Std.int(y), Std.int(width), Std.int(height));
                case CurveTo(controlX, controlY, anchorX, anchorY):
                    var path = currentPath;
                    if (path == null) {
                        path = gc.createPath();
                        path.moveToPoint(penPosX, penPosY);
                    }
                    path.addQuadCurveToPoint(controlX, controlY, anchorX, anchorY);
                    if (path == null) gc.strokeFillPath(path);
                case CubicCurveTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY):
                    var path = currentPath;
                    if (path == null) {
                        path = gc.createPath();
                        path.moveToPoint(penPosX, penPosY);
                    }
                    path.addCurveToPoint(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
                    if (path == null) gc.strokeFillPath(path);
                case BeginPath:
                    currentPath = gc.createPath();
                    currentPath.moveToPoint(penPosX, penPosY);
                case ClosePath:
                    currentPath.closeSubpath();
                    gc.strokeFillPath(currentPath, true, _currentBrushColor!= null);
                    
                    dc.brush = new Brush(_generalBrushColor);
                    gc.brush = new Brush(_generalBrushColor);
                    if (_generalBrushColor == null || _currentBrushAlpha == 0) {
                        dc.brush = StockBrushes.BRUSH_TRANSPARENT;
                        gc.brush = StockBrushes.BRUSH_TRANSPARENT;
                    }
                    currentPath = null;

                case _:
            }
        }
        dc.destroy();
        gc.destroy();

        e.stopPropagation();

        _requiresRefresh = false;
    }
}
