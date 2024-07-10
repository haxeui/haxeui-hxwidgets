package haxe.ui.backend.hxwidgets;

import hx.widgets.FontEnumerator;
import hx.widgets.FontEnumerator;
import hx.widgets.Font;
import hx.widgets.FontEnumerator;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import hx.widgets.Font;

class FontHelper {
    private static var fontNameCache:Map<String, String> = new Map<String, String>();
    public static function getFontName(resource:String):String {
        if (fontNameCache.exists(resource)) {
            return fontNameCache.get(resource);
        }

        var bytes = Resource.getBytes(resource);
        if (bytes == null) {
            return null;
        }

        var filename = Path.normalize(resource).split("/").pop();
        var appDir = new Path(Sys.programPath()).dir;
        var fullFilename = Path.normalize(appDir + "/" + filename);
        if (!FileSystem.exists(filename)) {
            File.saveBytes(fullFilename, bytes);
        }

        // sneaky way to get the font name
        var orgUseCache = FontEnumerator.useCache;
        FontEnumerator.useCache = false;
        var before = FontEnumerator.faceNames;
        Font.addPrivateFont(fullFilename);
        var after = FontEnumerator.faceNames;
        FontEnumerator.useCache = orgUseCache;

        for (item in before) {
            after.remove(item);
        }
        if (after.length != 1) {
            trace("WARNING: could not deduce font name for '" + resource + "'");
            return null;
        }

        var fontName = after[0];
        fontNameCache.set(resource, fontName);
        return fontName;
    }
}
