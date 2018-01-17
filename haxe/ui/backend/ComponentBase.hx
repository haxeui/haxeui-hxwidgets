package haxe.ui.backend;

import haxe.ui.backend.hxwidgets.Platform;
import haxe.ui.backend.hxwidgets.behaviours.ListViewDataSource;
import haxe.ui.backend.hxwidgets.custom.SimpleListView;
import haxe.ui.containers.ListView;
import haxe.ui.core.Screen;
import hx.widgets.Gauge;
import hx.widgets.Slider;
import hx.widgets.styles.ButtonStyle;
import hx.widgets.styles.TextCtrlStyle;
import hx.widgets.TextCtrl;
import hx.widgets.styles.StaticTextStyle;
import haxe.ui.backend.hxwidgets.ConstructorParams;
import haxe.ui.backend.hxwidgets.EventMapper;
import haxe.ui.backend.hxwidgets.RadioButtonGroups;
import haxe.ui.backend.hxwidgets.StyleParser;
import haxe.ui.backend.hxwidgets.TabViewIcons;
import haxe.ui.components.OptionBox;
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
import hx.widgets.CheckBox;
import hx.widgets.Choice;
import hx.widgets.Defs;
import hx.widgets.Dialog;
import hx.widgets.Direction;
import hx.widgets.Event;
import hx.widgets.EventType;
import hx.widgets.Font;
import hx.widgets.FontFamily;
import hx.widgets.FontStyle;
import hx.widgets.FontWeight;
import hx.widgets.HitTest;
import hx.widgets.Notebook;
import hx.widgets.Orientation;
import hx.widgets.PlatformInfo;
import hx.widgets.Point;
import hx.widgets.RadioButton;
import hx.widgets.ScrollBar;
import hx.widgets.ScrolledWindow;
import hx.widgets.Size;
import hx.widgets.StaticText;
import hx.widgets.Window;
import hx.widgets.styles.DialogStyle;
import hx.widgets.styles.RadioButtonStyle;
import hx.widgets.styles.WindowStyle;

class ComponentBase {
    private var _eventMap:Map<String, UIEvent->Void>;

    public function new() {
        _eventMap = new Map<String, UIEvent->Void>();
    }

    @:access(haxe.ui.containers.ListView)
    public function createDelegate(native:Bool) {
    }

    //***********************************************************************************************************
    // Text related
    //***********************************************************************************************************
    private var _textDisplay:TextDisplay;
    public function createTextDisplay(text:String = null):TextDisplay {
        if (_textDisplay == null) {
            _textDisplay = new TextDisplay();
            _textDisplay.parentComponent = cast this;
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
            _textInput.parentComponent = cast this;
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

        cast(this, Component).invalidateStyle();

        var className:String = Type.getClassName(Type.getClass(this));
        var nativeComponentClass:String = Toolkit.nativeConfig.query('component[id=${className}].@class', 'haxe.ui.backend.hxwidgets.custom.TransparentPanel', this);
        if (nativeComponentClass == null) {
            nativeComponentClass = "haxe.ui.backend.hxwidgets.custom.TransparentPanel";
        }
        if (nativeComponentClass == "haxe.ui.backend.hxwidgets.custom.TransparentPanel" && className == "haxe.ui.containers.ListView") {
            nativeComponentClass = "hx.widgets.ScrolledWindow";
        }

        var styleString:String = Toolkit.nativeConfig.query('component[id=${className}].@style', null, this);
        var style:Int = StyleParser.parseStyleString(styleString);

        if (Std.is(this, OptionBox)) {
            var optionBox:OptionBox = cast(this, OptionBox);
            if (RadioButtonGroups.exists(optionBox.groupName) == false) {
                style |= RadioButtonStyle.GROUP;
            }
            RadioButtonGroups.add(optionBox.groupName, optionBox);
        }

        var params:Array<Dynamic> = ConstructorParams.build(Toolkit.nativeConfig.query('component[id=${className}].@constructor', null, this), style);
        params.insert(0, parent);

        // special cases
        if (nativeComponentClass == "hx.widgets.StaticBitmap" || nativeComponentClass == "haxe.ui.backend.hxwidgets.custom.TransparentStaticBitmap") {
            var resource:String = cast(this, haxe.ui.components.Image).resource;
            if (resource != null) {
                params = [parent, Bitmap.fromHaxeResource(resource)];
            } else {
                params = [parent, Bitmap.fromHaxeResource("styles/FF00FF-0.png")];
            }
        } else if (nativeComponentClass == "hx.widgets.Dialog") {
            var dialog = cast(this, haxe.ui.containers.dialogs.Dialog);
            params = [parent, dialog.dialogOptions.title, DialogStyle.DEFAULT_DIALOG_STYLE | Defs.CENTRE];
        }
        
        window = Type.createInstance(Type.resolveClass(nativeComponentClass), params);
        if (window == null) {
            throw "Could not create window: " + nativeComponentClass;
        }

        if (Std.is(window, Notebook)) {
            var n:Notebook = cast window;
            if (Platform.isMac) {
                n.allowIcons = false;
            } else if (Platform.isWindows) {
                n.padding = new hx.widgets.Size(5,5);
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
            var iconIndex:Int = TabViewIcons.get(cast __parent, pageIcon);
            n.addPage(window, pageTitle, iconIndex);
            n.layout();
            n.refresh();
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

        if (Std.is(window, Button) || Std.is(window, StaticText)) {
            window.bind(EventType.ERASE_BACKGROUND, function(e) {

            });
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
    }

    private function handleAddComponent(child:Component):Component {
        cast(child, ComponentBase).__parent = cast this;
        __children.push(child);
        return child;
    }

    private function handleAddComponentAt(child:Component, index:Int):Component {
        cast(child, ComponentBase).__parent = cast this;
        __children.insert(index, child);
        return child;
    }
    
    private function handleRemoveComponent(child:Component, dispose:Bool = true):Component {
        __children.remove(child);
        if (child.window != null && dispose == true) {
            child.window.destroy();
            child.window = null;
        }
        return child;
    }

    private function handleRemoveComponentAt(index:Int, dispose:Bool = true):Component {
        var child = cast(this, Component)._children[index];
        return handleRemoveComponent(child, dispose);
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

        
        if (__parent != null && Std.is(__parent.window, Notebook) == false) {
            window.move(Std.int(left), Std.int(top));
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
    }

    private var _repositionUnlockCount:Int = 0;
    public function handlePreReposition():Void {
        if (window == null) {
            return;
        }
        return;
        if (window.beginRepositioningChildren() == true) {
            _repositionUnlockCount++;
        }
    }

    public function handlePostReposition():Void {
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

    private function handleSetComponentIndex(child:Component, index:Int) {

    }

    //***********************************************************************************************************
    // Redraw callbacks
    //***********************************************************************************************************
    private function applyStyle(style:Style) {
        if (window == null) {
            return;
        }

        var refreshWindow:Bool = false;

        if (style.backgroundColor != null) {
            window.backgroundColour = style.backgroundColor;
            if (Platform.isLinux && __children != null) { // wxPanels are opaque and you cant make them transparent on linux! :(
                for (c in __children) {
                    c.window.backgroundColour = style.backgroundColor;
                }
            }
            refreshWindow = true;
        }

        if (style.color != null) {
            window.foregroundColour = style.color;
            refreshWindow = true;
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

            if (style.textAlign != null) {
                var alignStyle:Int = switch(style.textAlign) {
                    case "left": ButtonStyle.LEFT;
                    case "right": ButtonStyle.RIGHT;
                    default: 0;
                }
                window.windowStyle = (window.windowStyle & ~(ButtonStyle.LEFT | ButtonStyle.RIGHT))   //Remove old align
                                    | alignStyle;
            }

            refreshWindow = true;
        } else if (Std.is(window, StaticText)) {
            if (style.textAlign != null) {
                var alignStyle:Int = switch(style.textAlign) {
                    case "center": StaticTextStyle.ALIGN_CENTRE_HORIZONTAL;
                    case "right": StaticTextStyle.ALIGN_RIGHT;
                    default: StaticTextStyle.ALIGN_LEFT;
                }
                window.windowStyle = (window.windowStyle & ~(StaticTextStyle.ALIGN_LEFT | StaticTextStyle.ALIGN_RIGHT | StaticTextStyle.ALIGN_CENTRE_HORIZONTAL))   //Remove old align
                                    | alignStyle;

                refreshWindow = true;
            }
        } else if(Std.is(window, TextCtrl)) {
            if (style.textAlign != null) {
                var alignStyle:Int = switch(style.textAlign) {
                    case "center": TextCtrlStyle.CENTRE;
                    case "right": TextCtrlStyle.RIGHT;
                    default: TextCtrlStyle.LEFT;
                }
                window.windowStyle = (window.windowStyle & ~(TextCtrlStyle.LEFT | TextCtrlStyle.RIGHT | TextCtrlStyle.CENTRE))   //Remove old align
                                    | alignStyle;

                refreshWindow = true;
            }
        }

        if (style.borderLeftSize != null && style.borderLeftSize > 0) {
            window.windowStyle |= WindowStyle.BORDER_STATIC;
        }
        
        if (refreshWindow == true) {
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
            window.font = font;
        }
    }

    private static inline function convertColor(c:Int) {
        return (c & 0x000000ff) << 16 | (c & 0x0000FF00) | (c & 0x00FF0000) >> 16;
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
    private function mapEvent(type:String, listener:UIEvent->Void) {
        if (window == null) {
            if (__eventsToMap == null) {
                __eventsToMap = new Map<String, UIEvent->Void>();
            }
            __eventsToMap.set(type, listener);
            return;
        }

        switch (type) {
            case MouseEvent.CLICK:
                if (_eventMap.exists(type) == false) {
                    _eventMap.set(type, listener);
                    window.bind(EventType.LEFT_DOWN, __onMouseDown);
                    window.bind(EventType.LEFT_UP, __onMouseUp);
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
                
                
            case UIEvent.CHANGE:
                if (Std.is(window, Notebook)) {
                    _eventMap.set(type, listener);
                    window.bind(EventType.NOTEBOOK_PAGE_CHANGED, __onChangeEvent);
                } else if (Std.is(window, RadioButton)) {
                    _eventMap.set(type, listener);
                    window.bind(EventType.RADIOBUTTON, __onChangeEvent);
                } else if (Std.is(window, CheckBox)) {
                    _eventMap.set(type, listener);
                    window.bind(EventType.CHECKBOX, __onChangeEvent);
                } else if (Std.is(window, Choice)) {
                    _eventMap.set(type, listener);
                    window.bind(EventType.CHOICE, __onChangeEvent);
                } else if (Std.is(window, Slider)) {
                    _eventMap.set(type, listener);
                    window.bind(EventType.SLIDER, __onChangeEvent);
                } else if (Std.is(window, SimpleListView)) {
                    _eventMap.set(type, listener);
                    window.bind(EventType.LIST_ITEM_SELECTED, __onChangeEvent);
                }
        }
    }
    
    private function unmapEvent(type:String, listener:UIEvent->Void) {
        if (window == null && __eventsToMap != null) {
            __eventsToMap.remove(type);
            return;
        }

        switch (type) {
            case MouseEvent.CLICK:
                _eventMap.remove(type);
                window.unbind(EventType.LEFT_DOWN, __onMouseDown);
                window.unbind(EventType.LEFT_UP, __onMouseUp);
            
            case MouseEvent.MOUSE_MOVE | MouseEvent.MOUSE_DOWN | MouseEvent.MOUSE_UP:
                _eventMap.remove(type);
                window.unbind(EventMapper.HAXEUI_TO_WX.get(type), __onMouseEvent);

            case MouseEvent.MOUSE_OVER | MouseEvent.MOUSE_OUT:
                
                
            case UIEvent.CHANGE:
                if (Std.is(window, Notebook)) {
                    _eventMap.remove(type);
                    window.unbind(EventType.NOTEBOOK_PAGE_CHANGED, __onChangeEvent);
                } else if (Std.is(window, RadioButton)) {
                    _eventMap.remove(type);
                    window.unbind(EventType.RADIOBUTTON, __onChangeEvent);
                } else if (Std.is(window, CheckBox)) {
                    _eventMap.remove(type);
                    window.unbind(EventType.CHECKBOX, __onChangeEvent);
                } else if (Std.is(window, Choice)) {
                    _eventMap.remove(type);
                    window.unbind(EventType.CHOICE, __onChangeEvent);
                } else if (Std.is(window, Slider)) {
                    _eventMap.remove(type);
                    window.unbind(EventType.SLIDER, __onChangeEvent);
                } else if (Std.is(window, SimpleListView)) {
                    _eventMap.remove(type);
                    window.unbind(EventType.LIST_ITEM_SELECTED, __onChangeEvent);
                }
        }
    }

    private function __onChangeEvent(event:Event) {
        var fn = _eventMap.get(UIEvent.CHANGE);
        if (fn != null) {
            var uiEvent:UIEvent = new UIEvent(UIEvent.CHANGE);
            fn(uiEvent);
        }
    }

    private static var _inComponents:Array<ComponentBase> = [];
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
    
    private function handleMouseOut(c:ComponentBase, mouseEvent:hx.widgets.MouseEvent) {
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
}