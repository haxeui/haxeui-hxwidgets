package haxe.ui.backend.hxwidgets.handlers;

import haxe.ui.core.Component;
import hx.widgets.Event;

class ReflectionHandler extends NativeHandler {
    private var _event:String = null;
    private var _eventId:Int = 0;
    private var _sourceProp:String = null;
    private var _targetProp:String = null;
    
    public function new(component:Component) {
        super(component);

        var className:String = Type.getClassName(Type.getClass(component));
        _event = Toolkit.nativeConfig.query('component[id=${className}].handler.@event', null, component);
        _sourceProp = Toolkit.nativeConfig.query('component[id=${className}].handler.@sourceProp', null, component);
        _targetProp = Toolkit.nativeConfig.query('component[id=${className}].handler.@targetProp', null, component);
        _eventId = EventTypeParser.fromString(_event);
    }
    
    public override function link() {
        if (_eventId != 0) {
            _component.window.bind(_eventId, onEvent);
        }
    }
    
    public override function unlink() {
        if (_eventId != 0) {
            _component.window.unbind(_eventId, onEvent);
        }
    }
    
    private function onEvent(event:Event) {
        Reflect.setProperty(_component, _targetProp, Reflect.getProperty(_component.window, _sourceProp));
    }
}