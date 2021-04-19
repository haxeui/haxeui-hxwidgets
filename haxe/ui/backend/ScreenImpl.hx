package haxe.ui.backend;

import haxe.ui.backend.hxwidgets.EventMapper;
import haxe.ui.backend.hxwidgets.MenuItemHelper;
import haxe.ui.containers.menus.Menu.MenuEvent;
import haxe.ui.containers.menus.MenuBar;
import haxe.ui.core.Component;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import hx.widgets.Event;
import hx.widgets.EventType;
import hx.widgets.Frame;

@:keep
class ScreenImpl extends ScreenBase {
    private var __eventMap:Map<String, UIEvent->Void>;
    
    public function new() {
        __eventMap = new Map<String, UIEvent->Void>();
    }

    public override function get_width():Float {
        return frame.clientSize.width;
    }
    
    public override function get_height():Float {
        return return frame.clientSize.height;
    }
    
    private var __topLevelComponents:Array<Component> = new Array<Component>();
    public override function addComponent(component:Component):Component {
        __topLevelComponents.push(component);
        addResizeListener();
        resizeComponent(component);
		return component;
    }

    public override function removeComponent(component:Component):Component {
        __topLevelComponents.remove(component);
        component.window.destroy();
		return component;
    }

    private override function resizeComponent(c:Component) {
        //c.lock();
        var cx:Null<Float> = null;
        var cy:Null<Float> = null;

        if (c.percentWidth > 0) {
            cx = (this.width * c.percentWidth) / 100;
        }
        if (c.percentHeight > 0) {
            cy = (this.height * c.percentHeight) / 100;
        }
        c.resizeComponent(cx, cy);
    }

    public var frame(get, null):Frame;
    private function get_frame():Frame {
        if (options == null || options.frame == null) {
            return null;
        }
        return  options.frame;
    }

    private override function get_title():String {
        return frame.title;
    }
    private override function set_title(t:String):String {
        return frame.title = t;
    }

    private var _hasListener:Bool = false;
    private function addResizeListener() {
        if (_hasListener == true || frame == null) {
            return;
        }

        frame.bind(EventType.SIZE, function(e) {
           for (c in __topLevelComponents) {
               resizeComponent(c);
           }
        });

        _hasListener = true;
    }

    private override function handleSetComponentIndex(child:Component, index:Int) {

    }

    private var _menuBar:MenuBar;
    private var _nativeMenuBar:hx.widgets.MenuBar;
    private function linkMenuBar(menuBar:MenuBar, nativeMenuBar:hx.widgets.MenuBar) {
        _menuBar = menuBar;
        _nativeMenuBar = nativeMenuBar;
        frame.menuBar = nativeMenuBar;
        frame.bind(EventType.MENU, onMenu);
    }
    
    private function onMenu(e:Event) {
        if (_menuBar == null) {
            return;
        }
        var menuItem = MenuItemHelper.get(e.id);
        if (menuItem != null) {
            var event = new MenuEvent(MenuEvent.MENU_SELECTED);
            event.menuItem = menuItem;
            _menuBar.dispatch(event);
        }
    }
    
    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private override function supportsEvent(type:String):Bool {
        if (type == MouseEvent.RIGHT_CLICK) {
            return true;
        }
        return false;
    }

    private override function mapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.RIGHT_CLICK:
                if (__eventMap.exists(MouseEvent.RIGHT_CLICK) == false) {
                    __eventMap.set(MouseEvent.RIGHT_CLICK, listener);
                    frame.children[0].bind(EventMapper.HAXEUI_TO_WX.get(MouseEvent.RIGHT_CLICK), __onMouseEvent);
                }
        }
    }

    private override function unmapEvent(type:String, listener:UIEvent->Void) {
        switch (type) {
            case MouseEvent.RIGHT_CLICK:
                __eventMap.remove(type);
                frame.children[0].unbind(EventMapper.HAXEUI_TO_WX.get(MouseEvent.RIGHT_CLICK), __onMouseEvent);
                
        }
    }
    
    private function __onMouseEvent(event:Event) {
        var type:String = EventMapper.WX_TO_HAXEUI.get(event.eventType);
        if (type != null) {
            var fn = __eventMap.get(type);
            if (fn != null) {
                var mouseEvent:hx.widgets.MouseEvent = event.convertTo(hx.widgets.MouseEvent);
                var newMouseEvent = new MouseEvent(type);
                newMouseEvent.screenX = mouseEvent.x;
                newMouseEvent.screenY = mouseEvent.y;
                fn(newMouseEvent);
            }
        }
    }
}
