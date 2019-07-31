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
        params.push(DialogStyle.DEFAULT_DIALOG_STYLE | Defs.CENTRE);
        return params;
    }
}