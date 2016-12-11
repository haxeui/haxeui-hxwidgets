package haxe.ui.backend.hxwidgets;

class ConstructorParams {
    public static function build(constructorSignature:String, style:Int):Array<Dynamic> {
        if (constructorSignature == null) {
            return [];
        }
        
        var constructorParams:Array<String> = constructorSignature.split(",");
        var params:Array<Dynamic> = [];
        for (constructorParam in constructorParams) {
            constructorParam = StringTools.trim(constructorParam);
            if (constructorParam == "$style") {
                params.push(style);
            } else if (constructorParam == "null") {
                params.push(null);
            } else if (constructorParam == "true" || constructorParam == "false") {
                params.push(constructorParam == "true");
            } else if (Std.parseInt(constructorParam) != null) {
                params.push(Std.parseInt(constructorParam));
            } else {
                params.push(constructorParam);
            }
        }
        
        return params;
    }
}