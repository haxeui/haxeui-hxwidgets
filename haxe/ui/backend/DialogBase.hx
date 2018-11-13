package haxe.ui.backend;

import haxe.ui.containers.Box;
import haxe.ui.containers.HBox;
import haxe.ui.containers.VBox;
import haxe.ui.core.Component;
import hx.widgets.Dialog;
import hx.widgets.SystemColour;
import hx.widgets.SystemMetric;
import hx.widgets.SystemSettings;

class DialogBase extends Component {
    public var modal:Bool = true;
    public var draggable:Bool = false;

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
        this.ready();
        this.width = this.childComponents[0].width + 6;
        this.height = this.childComponents[0].height + SystemSettings.getMetric(SystemMetric.CAPTION_Y) + 6;
        var dialog = cast(this.window, Dialog);
        dialog.centerOnParent();
        dialog.showModal();
    }

    public override function hide() {
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
}