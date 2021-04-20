package haxe.ui.backend;

import haxe.ui.backend.hxwidgets.ConstructorParams;
import haxe.ui.backend.hxwidgets.EventMapper;
import haxe.ui.backend.hxwidgets.EventTypeParser;
import haxe.ui.backend.hxwidgets.Platform;
import haxe.ui.backend.hxwidgets.StyleParser;
import haxe.ui.backend.hxwidgets.TabViewIcons;
import haxe.ui.backend.hxwidgets.creators.Creator;
import haxe.ui.backend.hxwidgets.handlers.NativeHandler;
import haxe.ui.containers.Box;
import haxe.ui.containers.TabView;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.core.Component;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.geom.Rectangle;
import haxe.ui.styles.Style;
import hx.widgets.Event;
import hx.widgets.EventType;
import hx.widgets.Font;
import hx.widgets.FontFamily;
import hx.widgets.FontStyle;
import hx.widgets.FontWeight;
import hx.widgets.HitTest;
import hx.widgets.Notebook;
import hx.widgets.Object;
import hx.widgets.Orientation;
import hx.widgets.Point;
import hx.widgets.ScrollBar;
import hx.widgets.ScrolledWindow;
import hx.widgets.Window;
import hx.widgets.styles.WindowStyle;

class ComponentImpl extends ComponentBase {
    private var _eventMap:Map<String, UIEvent->Void>;

    public function new() {
        super();
        _eventMap = new Map<String, UIEvent->Void>();
        if (Platform.isWindows) {
            cast(this, Component).addClass("platform-windows");
            if ((this is Dialog)) {
                cast(this, Component).addClass("custom-dialog-footer");
            }
        } else if (Platform.isMac) {
            cast(this, Component).addClass("platform-mac");
        } else if (Platform.isLinux) {
            cast(this, Component).addClass("platform-linux");
        }
    }

    //***********************************************************************************************************
    // Display tree
    //***********************************************************************************************************
    public var __parent:Component;
    private var __children:Array<ComponentImpl> = new Array<ComponentImpl>();

    public var object:Object = null;
    public var window(get, set):Window;
    private function get_window():Window {
        if (!(object is Window)) {
            return null;
        }
        return cast(object, Window);
    }
    private function set_window(value:Window):Window {
        object = value;
        return value;
    }
    
    public override function handleReady() {
        if (object != null) {
            return;
        }

        if (__parent == null) {
            createWindow();
        } else {
            createWindow(__parent.object);
        }

        for (c in __children) {
            c.handleReady();
        }
    }

    private override function get_isNativeScroller():Bool {
        return (window is ScrolledWindow);
    }
    
    private var _firstResize:Bool = false;
    
    @:access(haxe.ui.core.Component)
    private var __handler:NativeHandler = null;
    private function createWindow(parent:Object = null) {
        if (window != null) {
            return;
        }
        if (parent == null) {
            parent = Toolkit.screen.frame;
        }
        
        invalidateComponentStyle();

        var className:String = nativeClassName;
        var defaultNativeClass = "haxe.ui.backend.hxwidgets.custom.TransparentPanel";
        var nativeComponentClass:String = Toolkit.nativeConfig.query('component[id=${className}].@class', defaultNativeClass, this);
        
        if (cast(this, Component).native == false || cast(this, Component).native == null) {
            nativeComponentClass = defaultNativeClass;
        }
        
        if (nativeComponentClass == null) {
            nativeComponentClass = defaultNativeClass;
        }
        if (nativeComponentClass == defaultNativeClass && (className == "haxe.ui.containers.ListView")) {
            nativeComponentClass = "hx.widgets.ScrolledWindow";
        }

        var creatorClass:String = Toolkit.nativeConfig.query('component[id=${className}].@creator', null, this);
        if (creatorClass == null) {
            creatorClass = Toolkit.nativeConfig.query('component[class=${nativeComponentClass}].@creator', null, this);
        }
        var creator:Creator = null;
        if (creatorClass != null) {
            creator = Type.createInstance(Type.resolveClass(creatorClass), [this]);
        }
        
        
        var styleString:String = Toolkit.nativeConfig.query('component[id=${className}].@style', null, this);
        var style:Int = StyleParser.parseStyleString(styleString);
        if (creator != null) {
            style = creator.createStyle(style);
        }

        var params:Array<Dynamic> = ConstructorParams.build(Toolkit.nativeConfig.query('component[id=${className}].@constructor', null, this), style);
        params.insert(0, parent);

        if (creator != null) {
            params = creator.createConstructorParams(params);
            object = creator.createWindow(parent, style);
        }
        
        if (object == null) { // window may have been create with various special cases (menus for example)
            window = Type.createInstance(Type.resolveClass(nativeComponentClass), params);
        }
        if (object == null) {
            throw "Could not create window: " + nativeComponentClass;
        }
        
        if (window != null) {
            if (_hideOnCreate == true) {
                _hideOnCreate = false;
                window.show(false);
            } else if (__parent != null && __parent.window != null && (__parent.window is Notebook) == false) {
                window.show(false);
                _firstResize = true;
            }
            
            if ((window is Notebook)) {
                var n:Notebook = cast window;
                if (Platform.isMac) {
                    n.allowIcons = false;
                } else if (Platform.isWindows) {
                    n.padding = new hx.widgets.Size(8, 5);
                }
            }

            if ((window is ScrollBar)) {
                var scrollbar:ScrollBar = cast window;
                scrollbar.setScrollbar(0, 5, 100, 5);
            }

            if ((__parent is haxe.ui.containers.TabView)) {
                var n:Notebook = cast __parent.window;
                cast(this, Component).addClass("tab-page");
                var pageTitle:String = this.text;
                var pageIcon:String = cast(this, Box).icon;
                var iconIndex:Int = TabViewIcons.get(cast __parent, pageIcon);
                n.addPage(window, pageTitle, iconIndex);
                n.layout();
                n.refresh();
                
                this.registerEvent(UIEvent.PROPERTY_CHANGE, function(e) {
                    var pageIndex = parentComponent.childComponents.indexOf(cast(this, Component));
                    n.setPageText(pageIndex, this.text);
                });
            }

            if (Std.parseInt(cast(this, Component).id) != null) {
                window.id = Std.parseInt(cast(this, Component).id);
            }
        }

        if (__eventsToMap != null) {
            for (type in __eventsToMap.keys()) {
                mapEvent(type, __eventsToMap.get(type));
            }
            __eventsToMap = null;
        }

        if (__parent != null) {
            if (__parent._eventMap.exists(MouseEvent.MOUSE_OVER) || __parent._eventMap.exists(MouseEvent.MOUSE_OUT)) {
                if (__parent._eventMap.exists(MouseEvent.MOUSE_OVER)) {
                    _eventMap.set(MouseEvent.MOUSE_OVER, null);
                }
                if (__parent._eventMap.exists(MouseEvent.MOUSE_OUT)) {
                    _eventMap.set(MouseEvent.MOUSE_OUT, null);
                }
                window.bind(EventMapper.HAXEUI_TO_WX.get(MouseEvent.MOUSE_MOVE), function(e) { });
            }
        }
        
        var nativeHandlerClass:String = Toolkit.nativeConfig.query('component[id=${className}].handler.@class', null, this);
        if (nativeHandlerClass != null) {
            __handler = Type.createInstance(Type.resolveClass(nativeHandlerClass), [this]);
            __handler.link();
            if (_cachedStyle != null) {
                __handler.applyStyle(_cachedStyle);
                _cachedStyle = null;
            }
        }
    }

    private override function handleSize(width:Null<Float>, height:Null<Float>, style:Style) {
        if (width == null || height == null || width <= 0 || height <= 0) {
            return;
        }

        if (window == null) {
            return;
        }

        var w:Int = Std.int(width);
        var h:Int = Std.int(height);

        window.resize(w, h);
        if (__handler != null) {
            __handler.resize(w, h);
        }
        handleClipRect(null);
        if (_firstResize == true) {
            _firstResize = false;
            window.show(true);
        }
    }

    private override function handleAddComponent(child:Component):Component {
        cast(child, ComponentImpl).__parent = cast this;
        __children.push(child);
        return child;
    }

    private override function handleAddComponentAt(child:Component, index:Int):Component {
        cast(child, ComponentImpl).__parent = cast this;
        __children.insert(index, child);
        return child;
    }
    
    private override function handleRemoveComponent(child:Component, dispose:Bool = true):Component {
        __children.remove(child);
        if (child.window != null && dispose == true) {
            child.window.scheduleForDestruction();
            child.window = null;
        }
        return child;
    }

    private override function handleRemoveComponentAt(index:Int, dispose:Bool = true):Component {
        var child = cast(this, Component)._children[index];
        return handleRemoveComponent(child, dispose);
    }
    
    private var _hideOnCreate:Bool = false;
    private override function handleVisibility(show:Bool) {
        if (window != null) {
            window.show(show);
            window.refresh();
        } else {
            _hideOnCreate = !show;
        }
    }

    private override function handleClipRect(value:Rectangle):Void {
        if (__parent == null || __parent.window == null || (__parent.window is ScrolledWindow) == false) {
            return;
        }
        if (value != null) {
            if (this.width < value.width || this.height <= value.height) {
                return;
            }
        }
        var hscrollPos:Int = __parent.window.getScrollPos(Orientation.HORIZONTAL);
        var vscrollPos:Int = __parent.window.getScrollPos(Orientation.VERTICAL);
        var step:Int = 10;
        var cx = this.width + 1;
        var cy = this.height + 1;
        cast(__parent.window, ScrolledWindow).setScrollbars(step, step, Std.int(cx / step), Std.int(cy / step), hscrollPos, vscrollPos);
    }

    private override function handlePosition(left:Null<Float>, top:Null<Float>, style:Style):Void {
        if (window == null) {
            return;
        }
        
        if (__parent != null && (__parent.window is Notebook) == false) {
            window.move(Std.int(left), Std.int(top));
            if (Platform.isWindows) {
                window.refresh();
            }
        }
    }

    public function lock(recusive:Bool = false) {
        if (window == null) {
            return;
        }

        //window.freeze();
    }

    public function unlock(recusive:Bool = false) {
        if (window == null) {
            return;
        }

        //window.thaw();
        
        //window.refresh();
    }

    private var _repositionUnlockCount:Int = 0;
    public override function handlePreReposition():Void {
        if (window == null) {
            return;
        }
        return;
        if (window.beginRepositioningChildren() == true) {
            _repositionUnlockCount++;
        }
    }

    public override function handlePostReposition():Void {
        if (window == null) {
            return;
        }
        return;
        if (_repositionUnlockCount > 0) {
            window.endRepositioningChildren();
            _repositionUnlockCount--;
        }
        if (_repositionUnlockCount < 0) {
            _repositionUnlockCount = 0;
        }
    }

    private override function handleSetComponentIndex(child:Component, index:Int) {

    }

    //***********************************************************************************************************
    // Redraw callbacks
    //***********************************************************************************************************
    private var _cachedStyle:Style = null;
    private override function applyStyle(style:Style) {
        if (window == null || _ready == false) {
            _cachedStyle = style;
            return;
        }

        var refreshWindow:Bool = false;

        if (style.backgroundColor != null) {
            window.backgroundColour = style.backgroundColor;
            /*
            if (Platform.isLinux && __children != null) { // wxPanels are opaque and you cant make them transparent on linux! :(
                for (c in __children) {
                    if (c.window != null) {
                        c.window.backgroundColour = style.backgroundColor;
                    }
                }
            }
            */
            refreshWindow = true;
        }

        if (style.color != null) {
            window.foregroundColour = style.color;
            refreshWindow = true;
        }

        if (__handler != null) {
            refreshWindow = __handler.applyStyle(style);
        }
        
        if (style.borderLeftSize != null && style.borderLeftSize > 0 && !Platform.isLinux) {
            //window.windowStyle |= WindowStyle.BORDER_SIMPLE;
            window.windowStyle |= WindowStyle.BORDER_THEME;
        }
        
        if (refreshWindow == true) {
            window.refresh();
        }

        //if (Platform.isMac == false) { // dont bother trying to set the font on osx, it wont work and will look weird
            if (style.fontSize != null || style.fontBold != null || style.fontItalic != null || style.fontUnderline != null || style.fontName != null) {
                var fontSize:Int = 9;
                var fontFamily:FontFamily = FontFamily.DEFAULT;
                var fontStyle:FontStyle = FontStyle.NORMAL;
                var fontWeight:FontWeight = FontWeight.NORMAL;
                var fontUnderline:Bool = false;
                var fontFaceName = null;
                if (style.fontSize != null) {
                    fontSize = Std.int(style.fontSize) - 4;
                }
                if (style.fontName != null) {
                    var lcase = style.fontName.toLowerCase();
                    switch (lcase) {
                        case "default":
                            fontFamily = FontFamily.DEFAULT;
                        case "decorative":
                            fontFamily = FontFamily.DECORATIVE;
                        case "roman":
                            fontFamily = FontFamily.ROMAN;
                        case "script":
                            fontFamily = FontFamily.SCRIPT;
                        case "swiss":
                            fontFamily = FontFamily.SWISS;
                        case "modern":
                            fontFamily = FontFamily.MODERN;
                        case "teletype":
                            fontFamily = FontFamily.TELETYPE;
                        case _:
                            fontFamily = FontFamily.DEFAULT;
                            fontFaceName = style.fontName;
                    }
                }
                var font:Font = new Font(fontSize, fontFamily, fontStyle, fontWeight, fontUnderline, fontFaceName);
                window.font = font;
            }
        //}
    }

    private var __props:Map<String, Dynamic>;
    private function get(name:String):Dynamic {
        if (__props == null) {
            return null;
        }
        return __props.get(name);
    }

    private function set(name:String, value:Dynamic) {
        if (__props == null) {
            __props = new Map<String, Dynamic>();
        }
        __props.set(name, value);
    }

    private function has(name:String):Bool {
        if (__props == null) {
            return false;
        }
        return __props.exists(name);
    }

    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private var __eventsToMap:Map<String, UIEvent->Void>;
    private override function mapEvent(type:String, listener:UIEvent->Void) {
        if (window == null) {
            if (__eventsToMap == null) {
                __eventsToMap = new Map<String, UIEvent->Void>();
            }
            __eventsToMap.set(type, listener);
            return;
        }

        var className:String = Type.getClassName(Type.getClass(this));
        var native:String = Toolkit.nativeConfig.query('component[id=${className}].event[id=${type}].@native', null, this);
        if (native != null) {
            var eventType = EventTypeParser.fromString(native);
            if (eventType != 0) {
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    window.bind(eventType, __onEvent);
                }
                return;
            }
        }

        switch (type) {
            case MouseEvent.CLICK:
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    window.bind(EventType.LEFT_DOWN, __onMouseDown);
                    window.bind(EventType.LEFT_UP, __onMouseUp);
                }

            case MouseEvent.DBL_CLICK:
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    window.bind(EventType.LEFT_DCLICK, __onMouseEvent);
                }
                
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP:
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    window.bind(EventMapper.HAXEUI_TO_WX.get(type), __onMouseEvent);
                }

            case MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT:
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    window.bind(EventMapper.HAXEUI_TO_WX.get(MouseEvent.MOUSE_MOVE), __onMouseMove);
                    window.bind(EventMapper.HAXEUI_TO_WX.get(MouseEvent.MOUSE_OUT), __onMouseOut);
                }

            case MouseEvent.RIGHT_CLICK:    
                if (_eventMap.exists(MouseEvent.RIGHT_CLICK) == false) {
                    _eventMap.set(MouseEvent.RIGHT_CLICK, listener);
                    window.bind(EventMapper.HAXEUI_TO_WX.get(MouseEvent.RIGHT_CLICK), __onMouseEvent);
                }
            
            default:
        }
    }
    
    private override function unmapEvent(type:String, listener:UIEvent->Void) {
        if (window == null && __eventsToMap != null) {
            __eventsToMap.remove(type);
            return;
        }

        var className:String = Type.getClassName(Type.getClass(this));
        var native:String = Toolkit.nativeConfig.query('component[id=${className}].event[id=${type}].@native', null, this);
        if (native != null) {
            var eventType = EventTypeParser.fromString(native);
            if (eventType != 0) {
                _eventMap.remove(type);
                window.unbind(eventType, __onEvent);
                return;
            }
        }
        
        switch (type) {
            case MouseEvent.CLICK:
                _eventMap.remove(type);
                window.unbind(EventType.LEFT_DOWN, __onMouseDown);
                window.unbind(EventType.LEFT_UP, __onMouseUp);
            
            case MouseEvent.DBL_CLICK:
                _eventMap.remove(type);
                window.unbind(EventType.LEFT_DCLICK, __onMouseEvent);
                
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP:
                _eventMap.remove(type);
                window.unbind(EventMapper.HAXEUI_TO_WX.get(type), __onMouseEvent);

            case MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT:
                
            default:
        }
    }

    private function __onEvent(event:Event) {
        var className:String = Type.getClassName(Type.getClass(this));
        var nativeString = EventTypeParser.toString(event.eventType);
        var type = Toolkit.nativeConfig.query('component[id=${className}].event[native=${nativeString}].@id', null, this);
        if (type != null) {
            var fn = _eventMap.get(type);
            if (fn != null) {
                var cls = Toolkit.nativeConfig.query('component[id=${className}].event[native=${nativeString}].@class', "haxe.ui.events.UIEvent", this);
                switch (cls) {
                    case "haxe.ui.events.UIEvent":
                        var uiEvent:UIEvent = new UIEvent(type);
                        fn(uiEvent);
                    case "haxe.ui.events.MouseEvent":
                        var uiEvent:MouseEvent = new MouseEvent(type);
                        fn(uiEvent);
                    case _:    
                        var uiEvent:UIEvent = new UIEvent(type);
                        fn(uiEvent);
                }
            }
        }
    }

    private static var _inComponents:Array<ComponentImpl> = [];
    private var _mouseOverFlag:Bool = false;
    private function __onMouseMove(event:Event) {
        if (_mouseOverFlag == false) {
            _mouseOverFlag = true;
            
            var mouseEvent:hx.widgets.MouseEvent = event.convertTo(hx.widgets.MouseEvent);
            for (c in _inComponents) {
                handleMouseOut(c, mouseEvent);
            }
            
            _inComponents.push(this);
            
            var fn = _eventMap.get(MouseEvent.MOUSE_OVER);
            if (fn != null) {
                var newMouseEvent = new MouseEvent(MouseEvent.MOUSE_OVER);
                var pt:Point = new Point(mouseEvent.x, mouseEvent.y);
                pt = window.clientToScreen(pt);
                newMouseEvent.screenX = pt.x;
                newMouseEvent.screenY = pt.y;
                fn(newMouseEvent);
            }
        }
    }
    
    private var _mouseDownFlag:Bool = false;
    private function __onMouseDown(event:Event) {
        _mouseDownFlag = true;
    }
    
    private function __onMouseUp(event:Event) {
        if (_mouseDownFlag == true) {
            var fn = _eventMap.get(MouseEvent.CLICK);
            if (fn != null) {
                var mouseEvent:hx.widgets.MouseEvent = event.convertTo(hx.widgets.MouseEvent);
                var newMouseEvent = new MouseEvent(MouseEvent.CLICK);
                var pt:Point = new Point(mouseEvent.x, mouseEvent.y);
                pt = window.clientToScreen(pt);
                newMouseEvent.screenX = pt.x;
                newMouseEvent.screenY = pt.y;
                fn(newMouseEvent);
            }
        }
        _mouseDownFlag = false;
    }
    
    private function __onMouseOut(event:Event) {
        var mouseEvent:hx.widgets.MouseEvent = event.convertTo(hx.widgets.MouseEvent);
        var pt:Point = new Point(mouseEvent.x, mouseEvent.y);
        if (window.hitTest(pt) != HitTest.WINDOW_INSIDE && _mouseOverFlag == true) {
            handleMouseOut(this, mouseEvent);
        }
    }
    
    private function handleMouseOut(c:ComponentImpl, mouseEvent:hx.widgets.MouseEvent) {
        c._mouseOverFlag = false;
        _inComponents.remove(this);
        
        var fn = c._eventMap.get(MouseEvent.MOUSE_OUT);
        if (fn != null) {
            var newMouseEvent = new MouseEvent(MouseEvent.MOUSE_OUT);
            var pt:Point = new Point(mouseEvent.x, mouseEvent.y);
            pt = c.window.clientToScreen(pt);
            newMouseEvent.screenX = pt.x;
            newMouseEvent.screenY = pt.y;
            fn(newMouseEvent);
        }
    }
    
    private function __onMouseEvent(event:Event) {
        var type:String = EventMapper.WX_TO_HAXEUI.get(event.eventType);
        if (type != null) {
            var fn = _eventMap.get(type);
            if (fn != null) {
                var mouseEvent:hx.widgets.MouseEvent = event.convertTo(hx.widgets.MouseEvent);
                var newMouseEvent = new MouseEvent(type);
                newMouseEvent.screenX = Std.int(cast(this, Component).screenLeft) + mouseEvent.x;
                newMouseEvent.screenY = Std.int(cast(this, Component).screenTop) + mouseEvent.y;
                fn(newMouseEvent);
            }
        }
    }
 
    //***********************************************************************************************************
    // Helpers
    //***********************************************************************************************************
    
    public static inline function convertColor(c:Int) {
        return (c & 0x000000ff) << 16 | (c & 0x0000FF00) | (c & 0x00FF0000) >> 16;
    }

    public static inline function hash(s:String):Int {
        var hash:Int = 0;
        
        if (s != null && s.length > 0) {
            for (i in 0...s.length) {
                hash = 31 * hash + s.charCodeAt(i);
            }
        }
        
        return hash;
        
    }
}
