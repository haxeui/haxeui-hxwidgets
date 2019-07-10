package haxe.ui.backend;

import haxe.ui.core.Component;
import haxe.ui.events.UIEvent;
import hx.widgets.EventType;
import hx.widgets.Frame;

@:keep
class ScreenImpl extends ScreenBase {
    public function new() {
    }

    public override function get_width():Float {
        return frame.clientSize.width;
    }
    
    public override function get_height():Float {
        return return frame.clientSize.height;
    }
    
    private var __topLevelComponents:Array<Component> = new Array<Component>();
    public override function addComponent(component:Component) {
        __topLevelComponents.push(component);
        addResizeListener();
        resizeComponent(component);
    }

    public override function removeComponent(component:Component) {
        __topLevelComponents.remove(component);
        component.window.destroy();
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
               /*
               trace("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
               trace("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
               trace("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
               trace("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
               trace("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
               trace("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
               c.resizeComponent(500, null);
               */
           }
        });

        _hasListener = true;
    }

    private override function handleSetComponentIndex(child:Component, index:Int) {

    }

    //***********************************************************************************************************
    // Events
    //***********************************************************************************************************
    private override function supportsEvent(type:String):Bool {
        return false;
    }

    private override function mapEvent(type:String, listener:UIEvent->Void) {
    }

    private override function unmapEvent(type:String, listener:UIEvent->Void) {
    }
}
