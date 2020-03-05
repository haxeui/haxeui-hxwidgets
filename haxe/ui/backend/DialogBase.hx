package haxe.ui.backend;

import haxe.ui.backend.hxwidgets.Platform;
import haxe.ui.components.Button;
import haxe.ui.containers.Box;
import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.containers.dialogs.Dialog.DialogEvent;
import haxe.ui.core.Component;
import haxe.ui.events.MouseEvent;
import hx.widgets.BoxSizer;
import hx.widgets.Dialog;
import hx.widgets.Direction;
import hx.widgets.Orientation;
import hx.widgets.StandardId;
import hx.widgets.StdDialogButtonSizer;
import hx.widgets.Stretch;
import hx.widgets.SystemMetric;
import hx.widgets.SystemSettings;

class DialogBase extends Component {
    public var modal:Bool = true;
    public var buttons:DialogButton = null;
    public var draggable:Bool = false;
    public var centerDialog:Bool = true;
    public var button:DialogButton = null;

    public var dialogContentContainer:VBox;
    public var dialogContent:VBox;
    public var customDialogFooterContainer:Box;
    public var customDialogFooter:Box;

    public function new() {
        super();

        dialogContentContainer = new VBox();
        dialogContentContainer.addClass("dialog-container");
        
        dialogContent = new VBox();
        dialogContent.addClass("dialog-content");
        dialogContentContainer.addComponent(dialogContent);
        
        addComponent(dialogContentContainer);
    }

    public function showDialog(modal:Bool = true) {
        this.modal = modal;
        show();
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
        
        var dialog = cast(this.window, Dialog);
        
        var hm = 0;
        if (hasClass("custom-dialog-footer") == false && _buttonSizer == null) {
            createFooter();
            for (c in _footerComponents) {
                c.createWindow(dialog);
                c.ready();
                c.window.id = buttonToStandardId(c.userData);
                _buttonSizer.addButton(cast c.window);
                if (c.window.size.height > hm) {
                    hm = c.window.size.height;
                }
            }

            _buttonSizer.realize();
            
            dialog.sizer.add(dialogContentContainer.window, 1, Stretch.EXPAND | Direction.ALL, 0);
            dialog.sizer.addSizer(_buttonSizer, 0, Stretch.GROW | Direction.ALL, 5);
            if (hm > 0) {
                hm += 5;
            }
        }

        var m = 0;
        if (Platform.isWindows) {
            m = 6;
        } else if (Platform.isMac) {
	    hm = 65; // temp
	}
        
        if (autoWidth == true) {
            width = dialogContentContainer.width - m;
        } else {
            dialogContentContainer.width = this.width - m;
            dialogContent.width = null;
            dialogContent.percentWidth = 100;
        }

        if (autoHeight == true) {
            height = dialogContentContainer.height + SystemSettings.getMetric(SystemMetric.CAPTION_Y, Toolkit.screen.frame) + m + hm;
        } else {
            dialogContentContainer.height = this.height - SystemSettings.getMetric(SystemMetric.CAPTION_Y, Toolkit.screen.frame) - (m + hm);
            dialogContent.height = null;
            dialogContent.percentHeight = 100;
        }
        
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

    private function buttonToStandardId(button:DialogButton):Int {
        switch(button) {
            case DialogButton.SAVE:
                return StandardId.SAVE;
            case DialogButton.YES:
                return StandardId.YES;
            case DialogButton.NO:
                return StandardId.NO;
            case DialogButton.CLOSE:
                return StandardId.CLOSE;
            case DialogButton.OK:
                return StandardId.OK;
            case DialogButton.CANCEL:
                return StandardId.CANCEL;
            case DialogButton.APPLY:
                return StandardId.APPLY;
        }
        return StandardId.NONE;
    }
    
    private static function standardIdToButton(id:Int):DialogButton {
        if (id == StandardId.SAVE) {
            return DialogButton.SAVE;
        } else if (id == StandardId.YES) {
            return DialogButton.YES;
        } else if (id == StandardId.NO) {
            return DialogButton.NO;
        } else if (id == StandardId.CLOSE) {
            return DialogButton.CLOSE;
        } else if (id == StandardId.OK) {
            return DialogButton.OK;
        } else if (id == StandardId.CANCEL) {
            return DialogButton.CANCEL;
        } else if (id == StandardId.APPLY) {
            return DialogButton.APPLY;
        }
        return null;
    }

    private function validateDialog(button:DialogButton, fn:Bool->Void) {
        fn(true);
    }
    
    public override function hide() {
        validateDialog(this.button, function(result) {
            if (result == true) {
                var dialog = cast(this.window, Dialog);
                if (modal) {
                    var standardId = buttonToStandardId(button);
                    dialog.endModal(standardId);
                } else {
                    dialog.hide();
                    if (this.button == null) {
                        this.button = DialogButton.CANCEL;
                    }
                    var event = new DialogEvent(DialogEvent.DIALOG_CLOSED);
                    event.button = this.button;
                    dispatch(event);
                }
            }
        });
    }

    public function hideDialog(button:DialogButton) {
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
        if (child == dialogContentContainer) {
            return super.addComponent(child);
        }
        child.addClass("dialog-content");
        dialogContent.addComponent(child);
        return child;
    }

    private function createButtons() {
        
    }
    
    private var _buttonSizer:StdDialogButtonSizer = null;
    private function createFooter() {
        if (hasClass("custom-dialog-footer")) {
            if (customDialogFooter == null) {
                var line = new Box();
                line.percentWidth = 100;
                line.addClass("dialog-footer-line");
                line.height = 1;
                dialogContentContainer.addComponent(line);
                
                customDialogFooterContainer = new Box();
                customDialogFooterContainer.percentWidth = 100;
                customDialogFooterContainer.addClass("dialog-footer-container");
                dialogContentContainer.addComponent(customDialogFooterContainer);

                customDialogFooter = new HBox();
                customDialogFooter.horizontalAlign = "right";
                customDialogFooterContainer.addComponent(customDialogFooter);
            }
        } else {
            if (_buttonSizer == null && isReady == true) {
                var dialog:Dialog = cast(this.window, Dialog);
                _buttonSizer = dialog.createStdDialogButtonSizer(0);
                dialog.sizer = new BoxSizer(Orientation.VERTICAL);
            }
        }
    }

    private var _footerComponents:Array<Component> = [];
    public function addFooterComponent(c:Component) {
        createFooter();
        if (hasClass("custom-dialog-footer")) {
            customDialogFooter.addComponent(c);
        }
        _footerComponents.push(c);
    }
    
    private function onFooterButtonClick(event:MouseEvent) {
        hideDialog(event.target.userData);
    }
}
