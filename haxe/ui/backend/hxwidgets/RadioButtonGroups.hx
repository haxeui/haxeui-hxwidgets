package haxe.ui.backend.hxwidgets;
import haxe.ui.components.OptionBox;

class RadioButtonGroups {
    private static var _groups:Map<String, Array<OptionBox>>;
    
    public static function exists(name:String):Bool {
        return (group(name) != null);
    }
    
    public static function group(name:String):Array<OptionBox> {
        if (_groups == null) {
            return null;
        }
        
        var list:Array<OptionBox> = _groups.get(name);
        return list;
    }
    
    public static function add(name:String, control:OptionBox) {
        if (_groups == null) {
            _groups = new Map<String, Array<OptionBox>>();
        }
        
        var list:Array<OptionBox> = _groups.get(name);
        if (list == null) {
           list = new Array<OptionBox>();
           _groups.set(name, list);
        }
        
        list.push(control);
    }
}