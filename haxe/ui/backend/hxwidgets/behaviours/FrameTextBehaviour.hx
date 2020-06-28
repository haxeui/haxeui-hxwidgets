package haxe.ui.backend.hxwidgets.behaviours;

import haxe.ui.behaviours.DataBehaviour;
import hx.widgets.StaticBoxSizer;

class FrameTextBehaviour extends DataBehaviour {
    public override function validateData() {
        var sizer = cast(_component.userData, StaticBoxSizer);
        sizer.staticBox.label = _value;
    }
}