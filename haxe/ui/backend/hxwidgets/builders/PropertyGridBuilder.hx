package haxe.ui.backend.hxwidgets.builders;

import haxe.ui.containers.properties.Property;
import haxe.ui.containers.properties.PropertyGroup;
import haxe.ui.core.Component;
import haxe.ui.core.CompositeBuilder;
import haxe.ui.events.UIEvent;
import hx.widgets.Event;
import hx.widgets.EventType;
import hx.widgets.PGProperty;
import hx.widgets.PropertyGrid;
import hx.widgets.PropertyGridEvent;

class PropertyGridBuilder extends CompositeBuilder {
    private var _groups:Array<PropertyGroup> = [];
    private var _propertyMap:Map<Property, PGProperty> = new Map<Property, PGProperty>(); // we need to hold a map of created properties as they arent "real" windows in wx
    
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
                
                var itemId = groupId + "_" + item.label;

                // TODO: something strange going on with Variant here, shouldnt have to convert manually
                switch (item.type) {
                    case "boolean":
                        var prop = propGrid.appendBoolProperty(item.label, item.value == "true", itemId);
                        _propertyMap.set(item, prop);
                    case "int":
                        var prop = propGrid.appendIntProperty(item.label, Std.int(item.value), itemId);
                        _propertyMap.set(item, prop);
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
                        var prop = propGrid.appendEnumProperty(item.label, listItems, indexToSelect, itemId);
                        _propertyMap.set(item, prop);
                    default: 
                        var prop = propGrid.appendStringProperty(item.label, item.value, itemId);
                        _propertyMap.set(item, prop);
                }
            }
        }
        
        propGrid.bind(EventType.PG_CHANGED, onPropertyChanged);
    }
    
    private function onPropertyChanged(event:Event) {
        var propertyGridEvent = event.convertTo(PropertyGridEvent);
        var property = propertyGridEvent.property;
        var n = property.name;
        var target:Component = null;
        for (item in _propertyMap.keys()) {
            var prop = _propertyMap.get(item);
            if (prop.name == n) {
                convertValue(item, property.valueAsString);
                target = item;
                break;
            }
        }
        
        var event = new UIEvent(UIEvent.CHANGE);
        event.target = target;
        _component.dispatch(event);
    }
    
    public override function findComponent<T:Component>(criteria:String, type:Class<T>, recursive:Null<Bool>, searchType:String):Null<T> {
        if (searchType == "id" && criteria != null) {
            for (item in _propertyMap.keys()) {
                if (item.id == criteria) {
                    var prop = _propertyMap.get(item);
                    convertValue(item, prop.valueAsString);
                    return cast item;
                }
            }
        }
        
        return super.findComponent(criteria, type, recursive, searchType);
    }
    
    private function convertValue(item:Property, v:String) {
        switch (item.type) {
            case "boolean":
                item.value = (v.toLowerCase() == "true");
            case "int":
                item.value = Std.parseInt(v);
            case "list":
                item.value = v;
            default:    
                item.value = v;
        }
    }
    
}