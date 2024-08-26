package haxe.ui.backend.hxwidgets.builders;

import haxe.ui.containers.properties.Property;
import haxe.ui.containers.properties.PropertyGroup;
import haxe.ui.core.Component;
import haxe.ui.core.CompositeBuilder;

class PropertyGroupBuilder extends CompositeBuilder {
    public override function addComponent(child:Component):Component {
        if (!(child is Property) && !(child is PropertyGroup)) {
            return child;
        }
        return null;
    }
}