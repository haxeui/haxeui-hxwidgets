package haxe.ui.backend;

import haxe.ui.core.Platform;
import hx.widgets.SystemColour;
import hx.widgets.SystemMetric;
import hx.widgets.SystemSettings;

class PlatformImpl extends PlatformBase {
    public override function getMetric(id:String):Float {
        switch (id) {
            case Platform.METRIC_VSCROLL_WIDTH:
                return SystemSettings.getMetric(SystemMetric.VSCROLL_X);
            case Platform.METRIC_HSCROLL_HEIGHT:
                return SystemSettings.getMetric(SystemMetric.HSCROLL_Y);
        }
        return 0;
    }
    
    public override function getColor(id:String):Null<Int> {
        switch (id) {
            case "scrollbar":                   return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_SCROLLBAR));
            case "desktop":                     return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_DESKTOP));
            case "active-caption":              return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_ACTIVECAPTION));
            case "inactive-caption":            return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_INACTIVECAPTION));
            case "menu":                        return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_MENU));
            case "window":                      return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_WINDOW));
            case "window-frame":                return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_WINDOWFRAME));
            case "menu-text":                   return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_MENUTEXT));
            case "window-text":                 return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_WINDOWTEXT));
            case "caption-text":                return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_CAPTIONTEXT));
            case "active-border":               return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_ACTIVEBORDER));
            case "inactive-border":             return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_INACTIVEBORDER));
            case "app-workspace":               return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_APPWORKSPACE));
            case "highlight":                   return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_HIGHLIGHT));
            case "highlight-text":              return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_HIGHLIGHTTEXT));
            case "btn-face":                    return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_BTNFACE));
            case "btn-shadow":                  return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_BTNSHADOW));
            case "gray-text":                   return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_GRAYTEXT));
            case "btn-text":                    return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_BTNTEXT));
            case "inactive-caption-text":       return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_INACTIVECAPTIONTEXT));
            case "btn-highlight":               return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_BTNHIGHLIGHT));
            case "3d-dk-shadow":                return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_3DDKSHADOW));
            case "3d-light":                    return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_3DLIGHT));
            case "info-text":                   return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_INFOTEXT));
            case "info-bk":                     return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_INFOBK));
            case "listbox":                     return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_LISTBOX));
            case "hotlight":                    return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_HOTLIGHT));
            case "gradient-active-caption":     return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_GRADIENTACTIVECAPTION));
            case "gradient-inactive-caption":   return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_GRADIENTINACTIVECAPTION));
            case "menu-hilight":                return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_MENUHILIGHT));
            case "menubar":                     return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_MENUBAR));
            case "listbox-text":                return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_LISTBOXTEXT));
            case "listbox-highlight-text":      return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_LISTBOXHIGHLIGHTTEXT));
            case "background":                  return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_BACKGROUND));
            case "3d-face":                     return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_3DFACE));
            case "3d-shadow":                   return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_3DSHADOW));
            case "btn-hilight":                 return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_BTNHILIGHT));
            case "3d-highlight":                return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_3DHIGHLIGHT));
            case "3d-hilight":                  return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_3DHILIGHT));
            case "frame-bk":                    return ComponentImpl.convertColor(SystemSettings.getColour(SystemColour.COLOUR_FRAMEBK));
        }
        return null;
    }
}