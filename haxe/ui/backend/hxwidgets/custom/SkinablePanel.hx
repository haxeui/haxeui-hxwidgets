package haxe.ui.backend.hxwidgets.custom;

import haxe.ui.geom.Rectangle;
import haxe.ui.geom.Slice9;
import haxe.ui.geom.Slice9.Slice9Rects;
import haxe.ui.styles.Style;
import hx.widgets.Bitmap;
import hx.widgets.Brush;
import hx.widgets.GCDC;
import hx.widgets.GraphicsContext;
import hx.widgets.InterpolationQuality;
import hx.widgets.OwnerDrawnPanel;
import hx.widgets.Rect;
import hx.widgets.StockBrushes;
import hx.widgets.Window;
import hx.widgets.styles.WindowStyle;

class SkinablePanel extends OwnerDrawnPanel {
    public var style:Style = null;
    
    public function new(parent:Window) {
        super(parent, WindowStyle.FULL_REPAINT_ON_RESIZE | WindowStyle.CLIP_CHILDREN);
    }
    
    private override function onPaint(gdc:GCDC) {
        if (style == null) {
            return;
        }
        
        var size = this.clientSize;
        var cx = size.width;
        var cy = size.height;
        var ctx:GraphicsContext = gdc.graphicsContext;
        ctx.interpolationQuality = InterpolationQuality.NONE;
        if (style.backgroundColor != null) {
            gdc.background = new Brush(style.backgroundColor);
        } else {
            gdc.background = StockBrushes.BRUSH_TRANSPARENT;
        }
        gdc.clear();
        
        if (style.backgroundImage != null) {
            var backgroundImage = Bitmap.fromHaxeResource(style.backgroundImage);
            if (style.backgroundImageClipTop != null
                && style.backgroundImageClipLeft != null
                && style.backgroundImageClipBottom != null
                && style.backgroundImageClipRight != null) {
                    backgroundImage = backgroundImage.getSubBitmap(new Rect(Std.int(style.backgroundImageClipLeft), Std.int(style.backgroundImageClipTop), Std.int(style.backgroundImageClipRight - style.backgroundImageClipLeft), Std.int(style.backgroundImageClipBottom - style.backgroundImageClipTop)));
            }
            
            if (style.backgroundImageSliceTop != null
                && style.backgroundImageSliceLeft != null
                && style.backgroundImageSliceBottom != null
                && style.backgroundImageSliceRight != null) {
                
                var slice = new Rectangle(style.backgroundImageSliceLeft,
                                          style.backgroundImageSliceTop,
                                          style.backgroundImageSliceRight - style.backgroundImageSliceLeft,
                                          style.backgroundImageSliceBottom - style.backgroundImageSliceTop);
                    
                var w:Float = cx;
                var h:Float = cy;
                var rects:Slice9Rects = Slice9.buildRects(w, h, backgroundImage.width, backgroundImage.height, slice);
                
                for (i in 0...rects.src.length) {
                    var srcRect = rects.src[i];
                    var dstRect = rects.dst[i];

                    // have to fix the rects for some reason
                    if (i == 1) {
                        dstRect.width += 2;
                    }
                    else if (i == 3) {
                        dstRect.height += 2;
                    }
                    else if (i == 4) {
                        dstRect.width += 2;
                        dstRect.height += 2;
                    }
                    else if (i == 5) {
                        dstRect.height += 2;
                    }
                    else if (i == 7) {
                        dstRect.width += 2;
                    }
                    
                    var part = backgroundImage.getSubBitmap(new Rect(Std.int(srcRect.left), Std.int(srcRect.top), Std.int(srcRect.width), Std.int(srcRect.height)));
                    ctx.drawBitmap(part, dstRect.left, dstRect.top, dstRect.width, dstRect.height);
                }
                    
            } else {
                ctx.drawBitmap(backgroundImage, 0, 0, cx, cy);
            }
        }
    }
}