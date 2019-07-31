package haxe.ui.backend.hxwidgets.creators;

import haxe.ui.components.OptionBox;
import hx.widgets.styles.RadioButtonStyle;

class RadioButtonCreator extends Creator {
    private var _optionbox:OptionBox;
    
    public function new(optionbox:OptionBox) {
        super(optionbox);
        _optionbox = optionbox;
    }
    
    public override function createStyle(style:Int):Int {
        if (RadioButtonGroups.exists(_optionbox.componentGroup) == false) {
            style |= RadioButtonStyle.GROUP;
        }
        RadioButtonGroups.add(_optionbox.componentGroup, _optionbox);
        return style;
    }
}