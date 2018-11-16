package haxe.ui.backend;

import haxe.ui.components.Button;
import haxe.ui.containers.Box;
import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;
import haxe.ui.containers.dialogs.Dialog2.DialogButton2;
import haxe.ui.containers.dialogs.Dialog2.DialogEvent;
import haxe.ui.core.Component;
import haxe.ui.core.MouseEvent;
import hx.widgets.Defs;
import hx.widgets.Dialog;
import hx.widgets.StandardId;
import hx.widgets.SystemColour;
import hx.widgets.SystemMetric;
import hx.widgets.SystemSettings;

class DialogBase extends Component {
    public var modal:Bool = true;
    public var buttons:DialogButton2 = null;
    public var draggable:Bool = false;
    public var centerDialog:Bool = true;
    public var button:DialogButton2 = null;

    public var dialogContent:VBox;
    public var dialogFooterContainer:Box;
    public var dialogFooter:Box;

    public function new() {
        super();

        dialogContent = new VBox();
        dialogContent.addClass("hxwidgets-dialog-content");
        addComponent(dialogContent);
    }

    public override function show() {
        if (buttons != null) {
            for (button in buttons.toArray()) {
                var buttonComponent = new Button();
                buttonComponent.text = button.toString();
                buttonComponent.userData = button;
                buttonComponent.registerEvent(MouseEvent.CLICK, onFooterButtonClick);
                addFooterComponent(buttonComponent);
            }
        }
        
        this.ready();
        this.width = this.childComponents[0].width + 6;
        this.height = this.childComponents[0].height + SystemSettings.getMetric(SystemMetric.CAPTION_Y) + 6;
        var dialog = cast(this.window, Dialog);
        
        if (centerDialog) {
            dialog.centerOnParent();
        }
        if (modal) {
            var modalResult = dialog.showModal();
            if (modalResult != StandardId.NONE && standardIdToButton(modalResult) != null) {
                button = standardIdToButton(modalResult);
            }
            var event = new DialogEvent(DialogEvent.DIALOG_CLOSED);
            event.button = this.button;
            dispatch(event);
        } else {
            dialog.show();
        }
    }

    private function buttonToStandardId(button:DialogButton2):Int {
        switch(button) {
            case DialogButton2.SAVE:
                return StandardId.SAVE;
            case DialogButton2.YES:
                return StandardId.YES;
            case DialogButton2.NO:
                return StandardId.NO;
            case DialogButton2.CLOSE:
                return StandardId.CLOSE;
            case DialogButton2.OK:
                return StandardId.OK;
            case DialogButton2.CANCEL:
                return StandardId.CANCEL;
            case DialogButton2.APPLY:
                return StandardId.APPLY;
        }
        return StandardId.NONE;
    }
    
    private static function standardIdToButton(id:Int):DialogButton2 {
        if (id == StandardId.SAVE) {
            return DialogButton2.SAVE;
        } else if (id == StandardId.YES) {
            return DialogButton2.YES;
        } else if (id == StandardId.NO) {
            return DialogButton2.NO;
        } else if (id == StandardId.CLOSE) {
            return DialogButton2.CLOSE;
        } else if (id == StandardId.OK) {
            return DialogButton2.OK;
        } else if (id == StandardId.CANCEL) {
            return DialogButton2.CANCEL;
        } else if (id == StandardId.APPLY) {
            return DialogButton2.APPLY;
        }
        return null;
    }
    
    public override function hide() {
        var dialog = cast(this.window, Dialog);
        if (modal) {
            var standardId = buttonToStandardId(button);
            dialog.endModal(standardId);
        }
    }

    public function hideDialog(button:DialogButton2) {
        this.button = button;
        hide();
    }
    
    private var _title:String = "HaxeUI";
    public var title(get, set):String;
    private function get_title():String {
        return _title;
    }
    private function set_title(value:String):String {
        _title = value;
        return value;
    }

    public override function addComponent(child:Component):Component {
        if (child == dialogContent) {
            return super.addComponent(child);
        }
        child.addClass("dialog-content");
        dialogContent.addComponent(child);
        return child;
    }

    private function createFooter() {
        if (dialogFooter == null) {
            var line = new Box();
            line.percentWidth = 100;
            line.backgroundColor = ComponentBase.convertColor(SystemSettings.getColour(SystemColour.COLOUR_APPWORKSPACE));
            line.height = 1;
            dialogContent.addComponent(line);
            
            dialogFooterContainer = new Box();
            dialogFooterContainer.percentWidth = 100;
            dialogFooterContainer.addClass("dialog-footer-container");
            dialogFooterContainer.backgroundColor = ComponentBase.convertColor(SystemSettings.getColour(SystemColour.COLOUR_FRAMEBK));
            dialogContent.addComponent(dialogFooterContainer);

            dialogFooter = new HBox();
            dialogFooter.horizontalAlign = "right";
            dialogFooterContainer.addComponent(dialogFooter);
        }
    }

    public function addFooterComponent(c:Component) {
        createFooter();
        dialogFooter.addComponent(c);
    }
    
    private function onFooterButtonClick(event:MouseEvent) {
        hideDialog(event.target.userData);
    }
}