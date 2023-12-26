package haxe.ui.backend.hxwidgets.creators;
import haxe.ui.containers.dialogs.Dialog;
import hx.widgets.Defs;
import hx.widgets.styles.DialogStyle;

class DialogCreator extends Creator {
    private var _dialog:Dialog;
    
    public function new(dialog:Dialog) {
        super(dialog);
        _dialog = dialog;
    }
    
    public override function createConstructorParams(params:Array<Dynamic>):Array<Dynamic> {
        params.push(_dialog.title);
        var style = DialogStyle.CAPTION | DialogStyle.SYSTEM_MENU | Defs.CENTRE;
        if (_dialog.closable) style |= DialogStyle.CLOSE_BOX;
        params.push(style);
        return params;
    }
}