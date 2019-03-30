package haxe.ui.backend;

import haxe.ui.containers.dialogs.DialogButton;
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

    //***********************************************************************************************************
    // Dialogs
    //***********************************************************************************************************
    /*
    @:access(haxe.ui.core.Screen)
    public function messageDialog(message:String, title:String = null, options:Dynamic = null, callback:DialogButton->Void = null):Dialog {
        var dialogOptions:DialogOptions = Screen.createDialogOptions(options);
        var dialogStyle = 0;
        for (b in dialogOptions.buttons) {
            if (b.id == '${DialogButton.OK}') {
                dialogStyle |= Defs.OK;
            } else if (b.id  == '${DialogButton.CANCEL}') {
                dialogStyle |= Defs.CANCEL;
            } else if (b.id  == '${DialogButton.CLOSE}') {
                dialogStyle |= Defs.CLOSE;
            } else if (b.id  == '${DialogButton.CONFIRM}') {
                dialogStyle |= Defs.OK;
            } else if (b.id  == '${DialogButton.YES}') {
                dialogStyle |= Defs.YES;
            } else if (b.id  == '${DialogButton.NO}') {
                dialogStyle |= Defs.NO;
            }
        }

        if (dialogOptions.icon == DialogOptions.ICON_ERROR) {
            dialogStyle |= MessageDialogStyle.ICON_ERROR;
        } else if (dialogOptions.icon == DialogOptions.ICON_INFO) {
            dialogStyle |= MessageDialogStyle.ICON_INFORMATION;
        } else if (dialogOptions.icon == DialogOptions.ICON_WARNING) {
            dialogStyle |= MessageDialogStyle.ICON_WARNING;
        } else if (dialogOptions.icon == DialogOptions.ICON_QUESTION) {
            dialogStyle |= MessageDialogStyle.ICON_QUESTION;
        }

        var messageDialog:MessageDialog = new MessageDialog(frame, message, title, dialogStyle | Defs.CENTRE);
        messageDialog.showModal();
        return new Dialog();
    }
    */

    /*
    @:access(haxe.ui.core.Screen)
    public function showDialog(content:Component, options:Dynamic = null, callback:DialogButton->Void = null):Dialog {
        var dialogOptions:DialogOptions = Screen.createDialogOptions(options);
        */
        /*
        var dialog = new hx.widgets.Dialog(frame, "bob");
        dialog.showModal();
        */
        /*
        trace("HERE!");
        var t:Dialog = new Dialog();
        t.callback = callback;
        t.dialogOptions = dialogOptions;
        t.addComponent(content);
        Screen.instance.addComponent(t);
        var dlg:hx.widgets.Dialog = cast(t.window, hx.widgets.Dialog);
        dlg.centerOnParent();
        //dlg.resize(400, 400);
        //dlg.fit();
        dlg.showModal();
        trace(t.window);

        return new Dialog();
    }
    */

    /*
    public function hideDialog(dialog:Dialog):Bool {
        var dlg:hx.widgets.Dialog = cast(dialog.window, hx.widgets.Dialog);
        dlg.endModal(0);
        return true;
    }
    */

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
