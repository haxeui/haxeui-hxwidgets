package haxe.ui.backend.hxwidgets;

import hx.widgets.styles.*;

class StyleParser {
    public static function parseStyleString(styleString:String):Int {
        if (styleString == null) {
            return 0;
        }

        var style:Int = 0;
        var styles:Array<String> = styleString.split(",");
        for (s in styles) {
            s = StringTools.trim(s);
            style |= parseStyle(s);
        }
        return style;
    }

    public static function parseStyle(style:String):Int {
        if (style == null || style.length == 0) {
            return 0;
        }

        switch (style) {
            case "GaugeStyle.HORIZONTAL":               return GaugeStyle.HORIZONTAL;
            case "GaugeStyle.VERTICAL":                 return GaugeStyle.VERTICAL;
            case "SliderStyle.VERTICAL":                return SliderStyle.VERTICAL;
            case "SliderStyle.HORIZONTAL":              return SliderStyle.HORIZONTAL;
            case "ScrollBarStyle.HORIZONTAL":           return ScrollBarStyle.HORIZONTAL;
            case "ScrollBarStyle.VERTICAL":             return ScrollBarStyle.VERTICAL;
            case "TextCtrlStyle.MULTILINE":             return TextCtrlStyle.MULTILINE;
            case "TextCtrlStyle.HSCROLL":               return TextCtrlStyle.HSCROLL;
            case "DataViewCtrlStyle.DV_ROW_LINES":      return DataViewCtrlStyle.DV_ROW_LINES;
            default:
                trace('WARNING: hxWidgets style "${style}" not recognised');
        }

        return 0;
    }
}