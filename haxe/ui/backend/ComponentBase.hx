package haxe.ui.backend;

import haxe.ui.backend.hxwidgets.EventMapper;
import haxe.ui.backend.hxwidgets.StyleParser;
import haxe.ui.backend.hxwidgets.TabViewIcons;
import haxe.ui.containers.Box;
import haxe.ui.containers.TabView;
import haxe.ui.core.Component;
import haxe.ui.core.ImageDisplay;
import haxe.ui.core.MouseEvent;
import haxe.ui.core.TextDisplay;
import haxe.ui.core.TextInput;
import haxe.ui.core.UIEvent;
import haxe.ui.styles.Style;
import haxe.ui.util.Rectangle;
import hx.widgets.Bitmap;
import hx.widgets.Button;
import hx.widgets.Defs;
import hx.widgets.Dialog;
import hx.widgets.Direction;
import hx.widgets.Event;
import hx.widgets.EventType;
import hx.widgets.Font;
import hx.widgets.FontFamily;
import hx.widgets.FontStyle;
import hx.widgets.FontWeight;
import hx.widgets.Notebook;
import hx.widgets.Orientation;
import hx.widgets.PlatformInfo;
import hx.widgets.ScrollBar;
import hx.widgets.ScrolledWindow;
import hx.widgets.Size;
import hx.widgets.StaticText;
import hx.widgets.Window;
import hx.widgets.styles.DialogStyle;

class ComponentBase {
    private var _eventMap:Map<String, UIEvent->Void>;

    public function new() {
        _eventMap = new Map<String, UIEvent->Void>();
    }

    public function createDelegate(native:Bool) {
    }

    //***********************************************************************************************************
    // Text related
    //***********************************************************************************************************
    private var _textDisplay:TextDisplay;
    public function createTextDisplay(text:String = null):TextDisplay {
        if (_textDisplay == null) {
            _textDisplay = new TextDisplay();
        }
        if (text != null) {
            _textDisplay.text = text;
        }
        return _textDisplay;
    }

    public function getTextDisplay():TextDisplay {
        return createTextDisplay();
    }

    public function hasTextDisplay():Bool {
        return (_textDisplay != null);
    }

    private var _textInput:TextInput;
    public function createTextInput(text:String = null):TextInput {
        if (_textInput == null) {
            _textInput = new TextInput();
        }
        if (text != null) {
            _textInput.text = text;
        }
        return _textInput;
    }

    public function getTextInput():TextInput {
        return createTextInput();
    }

    public function hasTextInput():Bool {
        return (_textInput != null);
    }

    //***********************************************************************************************************
    // Image related
    //***********************************************************************************************************
    private var _imageDisplay:ImageDisplay;
    public function createImageDisplay():ImageDisplay {
        if (_imageDisplay == null) {
            _imageDisplay = new ImageDisplay();
        }
        return _imageDisplay;
    }

    public function getImageDisplay():ImageDisplay {
        return createImageDisplay();
    }

    public function hasImageDisplay():Bool {
        return (_imageDisplay != null);
    }

    public function removeImageDisplay():Void {
        if (_imageDisplay != null) {
            _imageDisplay.dispose();
            _imageDisplay = null;
        }
    }

    //***********************************************************************************************************
    // Display tree
    //***********************************************************************************************************
    public var __parent:Component;
    private var __children:Array<ComponentBase> = new Array<ComponentBase>();

    public function handleCreate(native:Bool) {
    }

    public var window:Window = null;
    public function handleReady() {
        if (window != null) {
            return;
        }

        if (__parent == null) {
            createWindow();
        } else {
            createWindow(__parent.window);
        }

        for (c in __children) {
            c.handleReady();
        }
    }

    private function createWindow(parent:Window = null) {
        if (parent == null) {
            parent = Toolkit.screen.frame;
        }

        cast(this, Component).invalidateStyle(false);

        var className:String = Type.getClassName(Type.getClass(this));
        var nativeComponentClass:String = Toolkit.nativeConfig.query('component[id=${className}].@class', 'hx.widgets.Panel');
        var styleString:String = Toolkit.nativeConfig.query('component[id=${className}].@style');

        var params:Array<Dynamic> = [parent];

        var style:Int = StyleParser.parseStyleString(styleString);
        // TODO: make this more dynamic, make a way to specific the constructor in the native config?
        if (nativeComponentClass == "hx.widgets.Gauge") {
            params = [parent, 100, style];
        } else if (nativeComponentClass == "hx.widgets.Slider") {
            params = [parent, 0, 0, 100, style];
        } else if (nativeComponentClass == "hx.widgets.ScrollBar") {
            params = [parent, style];
        } else if (nativeComponentClass == "hx.widgets.StaticBitmap") {
            var resource:String = cast(this, haxe.ui.components.Image).resource;
            params = [parent, Bitmap.fromHaxeResource(resource)];
        } else if (nativeComponentClass == "hx.widgets.Dialog") {
            var dialog = cast(this, haxe.ui.containers.dialogs.Dialog);
            params = [parent, dialog.dialogOptions.title, DialogStyle.DEFAULT_DIALOG_STYLE | Defs.CENTRE];
        }

        if (nativeComponentClass == null) {
            nativeComponentClass = "hx.widgets.Panel";
            params = [parent];
        }

        window = Type.createInstance(Type.resolveClass(nativeComponentClass), params);
        if (window == null) {
            throw "Could not create window: " + nativeComponentClass;
        }

        var platform:PlatformInfo = new PlatformInfo();
        if (Std.is(window, Notebook)) {
            if (platform.isWindows) {
                var n:Notebook = cast window;
                n.padding = new hx.widgets.Size(6, 6);
                //n.backgroundColour = 0xF0F0F0;
                //n.refresh();
            }
        }

        if (Std.is(window, ScrollBar)) {
            var scrollbar:ScrollBar = cast window;
            scrollbar.setScrollbar(0, 5, 100, 5);
        }

        if (Std.is(__parent, haxe.ui.containers.TabView)) {
            var n:Notebook = cast __parent.window;
            var pageTitle:String = cast(this, Component).text;
            var pageIcon:String = cast(this, Box).icon;
            var iconIndex:Int = TabViewIcons.getImageIndex(cast __parent, pageIcon);
            n.addPage(window, pageTitle, iconIndex);
        }

        if (Std.parseInt(cast(this, Component).id) != null) {
            window.id = Std.parseInt(cast(this, Component).id);
        }

        if (__eventsToMap != null) {
            for (type in __eventsToMap.keys()) {
                mapEvent(type, __eventsToMap.get(type));
            }
            __eventsToMap = null;
        }

    }

    private var _paintStyle:Style = null;
    private var _hasPaintHandler:Bool = false;
    private function onPaintEvent(e:Event) {
        var x:Float = 0;
        var y:Float = 0;
        var w:Float = window.clientSize.width;
        var h:Float = window.clientSize.height;

        var borderSize:Float = 1;

        /*
        var dc:PaintDC = new PaintDC(window);
        dc.clear();
        var gc:GraphicsContext = GraphicsContext.fromWindowDC(dc);
        gc.setInterpolationQuality(InterpolationQuality.NONE);

        // border size
        if (_paintStyle.borderLeftSize != null
            && _paintStyle.borderLeftSize == _paintStyle.borderRightSize
            && _paintStyle.borderLeftSize == _paintStyle.borderBottomSize
            && _paintStyle.borderLeftSize == _paintStyle.borderTopSize) { // full border
            borderSize = _paintStyle.borderLeftSize;
        }

        // border colour
        if (_paintStyle.borderLeftColor != null
            && _paintStyle.borderLeftColor == _paintStyle.borderRightColor
            && _paintStyle.borderLeftColor == _paintStyle.borderBottomColor
            && _paintStyle.borderLeftColor == _paintStyle.borderTopColor) {
            gc.setPen(new Pen(convertColor(_paintStyle.borderLeftColor), Std.int(borderSize)));
        }

        // background colour
        if (_paintStyle.backgroundColor != null) {
            gc.setBrush(new Brush(convertColor(_paintStyle.backgroundColor)));
        }

        var borderRadius:Float = 0;
        if (_paintStyle.borderRadius != null) {
            borderRadius = _paintStyle.borderRadius;
        }


        if (borderSize > 1) {
            x += Math.ffloor(borderSize / 2);
            y += Math.ffloor(borderSize / 2);
            w -= borderSize;
            h -= borderSize;
        } else if (borderSize != 0) {
            w--;
            h--;
        }
        gc.drawRoundedRectangle(x, y, w, h, borderRadius);

        //return;

        if (_paintStyle.backgroundImage != null) {
            trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> " + _paintStyle.backgroundImage);
            var bmp:Bitmap = Bitmap.fromHaxeResource(_paintStyle.backgroundImage);
            if (bmp != null) {
                var imageRect:Rectangle = new Rectangle(0, 0, bmp.getWidth(), bmp.getHeight());
                if (_paintStyle.backgroundImageClipTop != null
                    && _paintStyle.backgroundImageClipLeft != null
                    && _paintStyle.backgroundImageClipBottom != null
                    && _paintStyle.backgroundImageClipRight != null) {
                        imageRect = new Rectangle(_paintStyle.backgroundImageClipLeft,
                                                  _paintStyle.backgroundImageClipTop,
                                                  _paintStyle.backgroundImageClipRight - _paintStyle.backgroundImageClipLeft,
                                                  _paintStyle.backgroundImageClipBottom - _paintStyle.backgroundImageClipTop);
                }

                var slice:Rectangle = null;
                if (_paintStyle.backgroundImageSliceTop != null
                    && _paintStyle.backgroundImageSliceLeft != null
                    && _paintStyle.backgroundImageSliceBottom != null
                    && _paintStyle.backgroundImageSliceRight != null) {
                    slice = new Rectangle(_paintStyle.backgroundImageSliceLeft,
                                          _paintStyle.backgroundImageSliceTop,
                                          _paintStyle.backgroundImageSliceRight - _paintStyle.backgroundImageSliceLeft,
                                          _paintStyle.backgroundImageSliceBottom - _paintStyle.backgroundImageSliceTop);
                }

                if (slice == null) {
                    gc.drawBitmap(bmp, x, y, w, h);
                } else {
                    var rects:Slice9Rects = Slice9.buildRects(w + 1, h + 1, imageRect.width, imageRect.height, slice);
                    var srcRects:Array<Rectangle> = rects.src;
                    var dstRects:Array<Rectangle> = rects.dst;

                    for (i in 0...srcRects.length) {
                        var srcRect = new Rectangle(srcRects[i].left + imageRect.left,
                                                    srcRects[i].top + imageRect.top,
                                                    srcRects[i].width,
                                                    srcRects[i].height);
                        var dstRect = dstRects[i];
                        var sub:Bitmap = bmp.getSubBitmap(new Rect(Std.int(srcRect.left), Std.int(srcRect.top), Std.int(srcRect.width), Std.int(srcRect.height)));
                        if (i == 3 || i == 4 || i == 5) {
                            gc.drawBitmap(sub, dstRect.left, dstRect.top, dstRect.width, dstRect.height + 2);
                        } else {
                            gc.drawBitmap(sub, dstRect.left, dstRect.top, dstRect.width, dstRect.height);
                        }
                    }
                }
            }
        }
        */
    }

    private function addPaintHandler222() {
        return;
        if (_hasPaintHandler == true) {
            return;
        }

        window.bind(EventType.PAINT, onPaintEvent);
        /*
        window.bind(EventType.ERASE_BACKGROUND, function(e) {

        });
        */
        _hasPaintHandler = true;
    }

    private function handleSize(width:Null<Float>, height:Null<Float>, style:Style) {
        if (width == null || height == null || width <= 0 || height <= 0) {
            return;
        }

        if (window == null) {
            return;
        }

        var w:Int = Std.int(width);
        var h:Int = Std.int(height);
        window.resize(w, h);

        if (Std.is(window, StaticText)) {
            var l:StaticText = cast this.window;
            l.label = cast(this, Component).text;
            l.wrap(Std.int(width));
        } else {
            window.resize(Std.int(width), Std.int(height));
        }
    }

    private var _fake:String = null;
    private function handleAddComponent(child:Component):Component {
        cast(child, ComponentBase).__parent = cast this;
        __children.push(child);
        return child;
    }

    private function handleRemoveComponent(child:Component, dispose:Bool = true):Component {
        __children.remove(child);
        if (window != null) {
            window.destroy();
            window = null;
        }
        return child;
    }

    private function handleVisibility(show:Bool) {
        if (window != null) {
            window.show(show);
        }
    }

    private function handleClipRect(value:Rectangle):Void {
        if (__parent == null || __parent.window == null || Std.is(__parent.window, ScrolledWindow) == false) {
            return;
        }
        var hscrollPos:Int = __parent.window.getScrollPos(Orientation.HORIZONTAL);
        var vscrollPos:Int = __parent.window.getScrollPos(Orientation.VERTICAL);
        var step:Int = 20;
        cast(__parent.window, ScrolledWindow).setScrollbars(step, step, Std.int(cast(this, Component).componentWidth / step), Std.int(cast(this, Component).componentHeight / step), hscrollPos, vscrollPos);
        if (window != null) {
            //window.setSize(0, -vscrollPos * step, cast width, cast height);
        }
    }


    private function handlePosition(left:Null<Float>, top:Null<Float>, style:Style):Void {
        if (window == null) {
            return;
        }

        window.move(Std.int(left), Std.int(top));
    }

    public function lock(recusive:Bool = false) {
        if (window == null) {
            return;
        }

        window.freeze();
    }

    public function unlock(recusive:Bool = false) {
        if (window == null) {
            return;
        }

        window.thaw();
    }

    private var _repositionEndNeeded:Bool = false;
    public function handlePreReposition():Void {
        if (window == null) {
            return;
        }
        _repositionEndNeeded = window.beginRepositioningChildren();
    }

    public function handlePostReposition():Void {
        if (window == null) {
            return;
        }

        if (_repositionEndNeeded == true) {
            window.endRepositioningChildren();
            _repositionEndNeeded = false;
        }
    }

    private function handleSetComponentIndex(child:Component, index:Int) {
        
    }
    
    //***********************************************************************************************************
    // Redraw callbacks
    //***********************************************************************************************************
    private function applyStyle(style:Style) {
        //return;
        if (window == null) {
            return;
        }

        var refreshWindow:Bool = false;

        /*
        if (_hasPaintHandler == true) {
            _paintStyle = style;
            window.refresh();
            //window.update();
            return;
            refreshWindow = true;
        }
        */

        if (style.backgroundColor != null && _hasPaintHandler == false) {
            //trace(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> " + this + " --- " + StringTools.hex(style.backgroundColor));
            window.backgroundColour = convertColor(style.backgroundColor);
            refreshWindow = true;
        }

        if (style.color != null) {
            window.foregroundColour = convertColor(style.color);
            refreshWindow = true;
        }

        if (refreshWindow == true) {
            window.refresh();
        }

        if (Std.is(window, Button)) {
            var button:Button = cast window;
            switch (style.iconPosition) {
                case "right":
                    button.bitmapPosition = Direction.RIGHT;
                case "top":
                    button.bitmapPosition = Direction.TOP;
                case "bottom":
                    button.bitmapPosition = Direction.BOTTOM;
                default:
                    button.bitmapPosition = Direction.LEFT;
            }
        }

        if (style.fontSize != null || style.fontBold != null || style.fontItalic != null || style.fontUnderline != null) {
            var fontSize:Int = 9;
            var fontFamily:FontFamily = FontFamily.DEFAULT;
            var fontStyle:FontStyle = FontStyle.NORMAL;
            var fontWeight:FontWeight = FontWeight.NORMAL;
            var fontUnderline:Bool = false;
            if (style.fontSize != null) {
                fontSize = Std.int(style.fontSize) - 4;
            }

            var font:Font = new Font(fontSize, fontFamily, fontStyle, fontWeight, fontUnderline);
            window.font = font;
        }

        /*
        if (style.hidden != null) {
            if (style.hidden == true) {
                window.show(false);
            } else {
                window.show(true);
            }
        }
        */









        /*
        if (style.backgroundColor != null) {
            window.backgroundColour = style.backgroundColor;
            window.refresh();
        }

        if (style.color != null) {
            window.foregroundColour = style.color;
            window.refresh();
        }

        if (style.fontSize != null || style.fontBold != null || style.fontItalic != null || style.fontUnderline != null) {
            var fontSize:Int = 9;
            var fontFamily:FontFamily = FontFamily.DEFAULT;
            var fontStyle:FontStyle = FontStyle.NORMAL;
            var fontWeight:FontWeight = FontWeight.NORMAL;
            var fontUnderline:Bool = false;
            if (style.fontSize != null) {
                fontSize = Std.int(style.fontSize) - 4;
            }

            var font:Font = new Font(fontSize, fontFamily, fontStyle, fontWeight, fontUnderline);
            window.setFont(font);
        }
        */
    }

    private static inline function convertColor(c:Int) {
        return (c & 0x000000ff) << 16 | (c & 0x0000FF00) | (c & 0x00FF0000) >> 16;
    }

    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private var __eventsToMap:Map<String, UIEvent->Void>;
    private function mapEvent(type:String, listener:UIEvent->Void) {
        if (window == null) {
            if (__eventsToMap == null) {
                __eventsToMap = new Map<String, UIEvent->Void>();
            }
            __eventsToMap.set(type, listener);
            return;
        }

        switch (type) {
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT
                | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP | MouseEvent.CLICK:
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    window.bind(EventMapper.HAXEUI_TO_WX.get(type), __onMouseEvent);
                }

            case UIEvent.CHANGE:
                if (Std.is(window, Notebook)) {
                    _eventMap.set(type, listener);
                    window.bind(EventType.NOTEBOOK_PAGE_CHANGED, __onTabsChanged);
                }
        }
    }

    private function unmapEvent(type:String, listener:UIEvent->Void) {
        if (window == null && __eventsToMap != null) {
            __eventsToMap.remove(type);
            return;
        }

        switch (type) {
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT
                | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP | MouseEvent.CLICK:
                _eventMap.remove(type);
                window.unbind(EventMapper.HAXEUI_TO_WX.get(type), __onMouseEvent);
        }
    }

    private function __onTabsChanged(event:Event) {
        var fn = _eventMap.get(UIEvent.CHANGE);
        if (fn != null) {
            var uiEvent:UIEvent = new UIEvent(UIEvent.CHANGE);
            fn(uiEvent);
        }
    }

    private function __onMouseEvent(event:Event) {
        var mouseEvent:hx.widgets.MouseEvent = event.convertTo(hx.widgets.MouseEvent);
        var type:String = EventMapper.WX_TO_HAXEUI.get(event.eventType);
        if (type != null) {
            var fn = _eventMap.get(type);
            if (fn != null) {
                var mouseEvent = new MouseEvent(type);
                //mouseEvent.screenX = event.pageX;
                //mouseEvent.screenY = event.pageY;
                fn(mouseEvent);
            }
        }
    }
}