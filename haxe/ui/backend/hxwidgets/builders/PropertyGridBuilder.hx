package haxe.ui.backend.hxwidgets.builders;

import haxe.ui.containers.properties.Property;
import haxe.ui.containers.properties.PropertyGroup;
import haxe.ui.core.Component;
import haxe.ui.core.CompositeBuilder;
import hx.widgets.PropertyGrid;

class PropertyGridBuilder extends CompositeBuilder {
    private var _groups:Array<PropertyGroup> = [];
    
    public override function addComponent(child:Component):Component {
        if (Std.is(child, PropertyGroup)) {
            _groups.push(cast(child, PropertyGroup));
            return child;
        }
        
        return null;
    }
    
    public override function onReady() {
        var propGrid:PropertyGrid = cast(_component.window, PropertyGrid);
        for (group in _groups) {
            var groupId = group.text;
            propGrid.appendCategory(groupId);
            for (i in group.childComponents) {
                var item = cast(i, Property);
                
                var itemId = groupId + "_" + item.text;

                // TODO: something strange going on with Variant here, shouldnt have to convert manually
                switch (item.type) {
                    case "boolean":
                        propGrid.appendBoolProperty(item.text, item.value == "true", itemId);
                    case "int":
                        propGrid.appendIntProperty(item.text, Std.int(item.value), itemId);
                    case "list":
                        var ds = item.dataSource;
                        var listItems = [];
                        var indexToSelect = 0;
                        for (dsi in 0...ds.size) {
                            var data = ds.get(dsi);
                            listItems.push({
                                label: data.value
                            });
                            if (data.value == item.value) {
                                indexToSelect = dsi;
                            }
                        }
                        propGrid.appendEnumProperty(item.text, listItems, indexToSelect, itemId);
                    default: 
                        propGrid.appendStringProperty(item.text, item.value, itemId);
                }
                
            }
        }
    }
    
}