package haxe.ui.backend;

import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.MessageBox.MessageBoxType;
import haxe.ui.core.Screen;
import hx.widgets.MessageDialog;
import hx.widgets.styles.MessageDialogStyle;

class MessageBoxBase extends Dialog {
    public function new() {
        super();
    }
    
    public override function show() {
        var style = MessageDialogStyle.ICON_INFORMATION;
        switch (_type) {
            case MessageBoxType.TYPE_INFO:
                style = MessageDialogStyle.ICON_INFORMATION;
            case MessageBoxType.TYPE_QUESTION:
                style = MessageDialogStyle.YES_NO;
            case MessageBoxType.TYPE_WARNING:
                style = MessageDialogStyle.ICON_WARNING;
            case MessageBoxType.TYPE_ERROR:
                style = MessageDialogStyle.ICON_ERROR;
        }
        var dialog:MessageDialog = new MessageDialog(Screen.instance.frame, _message, title, style);
        var retVal = dialog.showModal();
        var event = new DialogEvent(DialogEvent.DIALOG_CLOSED);
        event.button = DialogBase.standardIdToButton(retVal);
        dispatch(event);
    }
    
    private var _message:String;
    public var message(get, set):String;
    private function get_message():String {
        return _message;
    }
    private function set_message(value:String):String {
        _message = value;
        return value;
    }
    
    private var _type:MessageBoxType;
    public var type(get, set):MessageBoxType;
    private function get_type():MessageBoxType {
        return _type;
    }
    private function set_type(value:MessageBoxType):MessageBoxType {
        _type = value;
        return value;
    }
}