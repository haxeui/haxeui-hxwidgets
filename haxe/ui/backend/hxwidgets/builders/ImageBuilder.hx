package haxe.ui.backend.hxwidgets.builders;

import haxe.ui.components.Image;
import haxe.ui.core.CompositeBuilder;
import haxe.ui.styles.Style;

@:dox(hide) @:noCompletion
class ImageBuilder extends CompositeBuilder {
    private var _image:Image;
    
    public function new(image:Image) {
        super(image);
        _image = image;
    }
    
    public override function applyStyle(style:Style) {
        if (style.resource != null) {
            _image.resource = style.resource;
        }
    }
}
