package haxe.ui.backend.hxwidgets.builders;

import haxe.ui.containers.properties.Property;
import haxe.ui.containers.properties.PropertyEditor.*;
import haxe.ui.containers.properties.PropertyEditor;
import haxe.ui.containers.properties.PropertyGrid;
import haxe.ui.containers.properties.PropertyGroup;
import haxe.ui.core.Component;
import haxe.ui.core.CompositeBuilder;
import haxe.ui.events.UIEvent;
import haxe.ui.util.Color;
import haxe.ui.util.GUID;
import hx.widgets.BoolProperty;
import hx.widgets.ColourProperty;
import hx.widgets.EnumProperty;
import hx.widgets.Event;
import hx.widgets.EventType;
import hx.widgets.IntProperty;
import hx.widgets.PGProperty;
import hx.widgets.PropertyGrid as NativePropertyGrid;
import hx.widgets.PropertyGridEvent;
import hx.widgets.StringProperty;
import hx.widgets.SystemColour;
import hx.widgets.SystemSettings;
import hx.widgets.styles.PropertyGridAttributes;
import hx.widgets.ScrollbarVisibility;

class PropertyGridBuilder extends CompositeBuilder {
    private var useCategories:Bool = false;
    private var propertyIdToProperty:Map<String, Property> = new Map<String, Property>();
    private var propertyToNativeProperty:Map<Property, PGProperty> = new Map<Property, PGProperty>();

    public override function create() {
        super.create();
    }

    public override function onInitialize() {
        super.onInitialize();

        var nativePropertyGrid:NativePropertyGrid = cast _component.window;
        nativePropertyGrid.showScrollbars(ScrollbarVisibility.NEVER, ScrollbarVisibility.DEFAULT);
        nativePropertyGrid.bind(EventType.PG_CHANGED, onPGChanged);

        if (haxe.ui.core.Platform.instance.isWindows) {
            nativePropertyGrid.setMarginColour(SystemSettings.getColour(SystemColour.COLOUR_BTNFACE));
            nativePropertyGrid.setLineColour(SystemSettings.getColour(SystemColour.COLOUR_BTNFACE));
        }

        var properties = _component.findComponents(Property);
        recursePropertiesAndGroups(_component, nativePropertyGrid, null);
    }

    private function onPGChanged(event:Event) {
        var propertyGridEvent = event.convertTo(PropertyGridEvent);
        var property = propertyGridEvent.property;
        var propertyId = property.name.split(".").pop();
        var prop = propertyIdToProperty.get(propertyId);
        if (prop != null) {
            prop.value = property.getValue();
        }
    }

    private function onPropertyValueChanged(event:UIEvent) {
        var prop:Property = cast(event.target, Property);
        var nativeProp = findNativePGProperty(prop);
        if (nativeProp != null) {
            var nativePropertyGrid:NativePropertyGrid = cast _component.window;
            nativeProp.setValue(prop.value);
            dispatchChangedEvents(prop);
        }
    }

    private function dispatchChangedEvents(prop:Property) {
        var event = new UIEvent(UIEvent.CHANGE);
        event.relatedComponent = prop;
        _component.dispatch(event);

        if (prop != null) {
            event = new UIEvent(UIEvent.CHANGE);
            event.relatedComponent = prop;
            prop.dispatch(event);
        }
    }

    private function findNativePGProperty(prop:Property):PGProperty {
        return propertyToNativeProperty.get(prop);
    }

    private function recursePropertiesAndGroups(parent:Component, nativePropertyGrid:NativePropertyGrid, nativePropertyParent:PGProperty) {
        for (child in parent.childComponents) {
            if ((child is Property)) {
                var prop:Property = cast child;
                var nativeProperty = buildNativeProperty(prop, nativePropertyGrid, nativePropertyParent);
            } else if ((child is PropertyGroup)) {
                var group:PropertyGroup = cast child;
                var nativePropId = GUID.uuid();
                var nativeProp:PGProperty = null;
                if (nativePropertyParent == null) {
                    if (useCategories) {
                        nativeProp = nativePropertyGrid.appendCategory(group.text, nativePropId);
                    } else {
                        nativeProp = nativePropertyGrid.appendStringProperty(group.text, "", nativePropId);
                    }
                } else {
                    if (useCategories) {
                        nativeProp = nativePropertyGrid.appendCategoryIn(nativePropertyParent, group.text, nativePropId);
                    } else {
                        nativeProp = nativePropertyGrid.appendStringPropertyIn(nativePropertyParent, group.text, "", nativePropId);
                    }
                }
                recursePropertiesAndGroups(child, nativePropertyGrid, nativeProp);
                if (haxe.ui.core.Platform.instance.isWindows) {
                    nativePropertyGrid.setPropertyBackgroundColour(nativeProp, SystemSettings.getColour(SystemColour.COLOUR_BTNFACE));
                }
            }
        }
    }

    private function buildNativeProperty(prop:Property, nativePropertyGrid:NativePropertyGrid, nativePropertyParent:PGProperty):PGProperty {
        var nativePropId = GUID.uuid();
        var nativeProp:PGProperty = null;

        var nativeProp:PGProperty = null;
        var editorInfo = PropertyGrid.getRegisteredEditorInfo(prop.type);
        if (editorInfo != null) {
            switch (editorInfo.editorClass) {
                case PropertyEditorBoolean:
                    nativeProp = new BoolProperty(prop.label, nativePropId, prop.value);
                    nativeProp.setAttribute(PropertyGridAttributes.BOOL_USE_CHECKBOX, true);
                case PropertyEditorNumber:
                    nativeProp = new IntProperty(prop.label, nativePropId, prop.value);
                case PropertyEditorList | PropertyEditorOptions:
                    var ds = prop.dataSource;
                    var listItems = [];
                    var indexToSelect = 0;
                    for (dsi in 0...ds.size) {
                        var data = ds.get(dsi);
                        listItems.push({
                            label: data.text
                        });
                        if (data.text == prop.value) {
                            indexToSelect = dsi;
                        }
                    }
                    nativeProp = new EnumProperty(prop.label, nativePropId, listItems, indexToSelect);
                case PropertyEditorColor:
                    var c = Color.fromString(prop.value);
                    nativeProp = new ColourProperty(prop.label, nativePropId, ComponentImpl.convertColor(c.toInt()));
                case _:    
                    nativeProp = new StringProperty(prop.label, nativePropId, prop.value);
            }
        } else {
            nativeProp = new StringProperty(prop.label, nativePropId, prop.value);
        }

        if (nativeProp != null) {
            if (nativePropertyParent == null) {
                nativeProp = nativePropertyGrid.append(nativeProp);
            } else {
                nativeProp = nativePropertyGrid.appendIn(nativePropertyParent, nativeProp);
            }
            propertyIdToProperty.set(nativePropId, prop);
            propertyToNativeProperty.set(prop, nativeProp);
            prop.registerEvent(UIEvent.PROPERTY_CHANGE, onPropertyValueChanged);
        }
        return nativeProp;
    }
}