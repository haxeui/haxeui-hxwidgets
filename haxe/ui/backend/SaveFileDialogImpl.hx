package haxe.ui.backend;

import haxe.io.Path;
import haxe.ui.core.Screen;
import hx.widgets.FileDialog;
import hx.widgets.StandardId;
import hx.widgets.styles.FileDialogStyle;
import sys.io.File;

using StringTools;

class SaveFileDialogImpl extends SaveFileDialogBase {
    public override function show() {
        if (fileInfo == null || (fileInfo.text == null && fileInfo.bytes == null)) {
            throw "Nothing to write";
        }
        
        var message = options.title;
        if (message == null) {
            message = "Save File";
        }
        var pattern = buildPattern();
        var style = FileDialogStyle.SAVE | FileDialogStyle.OVERWRITE_PROMPT;
        var nativeDialog = new FileDialog(Screen.instance.frame, message, null, fileInfo.name, pattern, style);
        var r = nativeDialog.showModal();
        if (r == StandardId.OK) {
            var fullPath = Path.normalize(nativeDialog.directory + "/" + nativeDialog.filename);
            if (fileInfo.text != null) {
                File.saveContent(fullPath, fileInfo.text);
            } else if (fileInfo.bytes != null) {
                File.saveBytes(fullPath, fileInfo.bytes);
            }
            dialogConfirmed();
        } else {
            dialogCancelled();
        }
    }
    
    private function buildPattern():String {
        var s = "All Files (*.*)|*.*";
        if (options.extensions != null && options.extensions.length > 0) {
            var arr = [];
            for (e in options.extensions) {
                var ext = e.extension;
                ext = ext.trim();
                if (ext.length == 0) {
                    continue;
                }
                var single = e.label;
                var parts = ext.split(",");
                var finalParts = [];
                for (p in parts) {
                    p = p.trim();
                    if (p.length == 0) {
                        continue;
                    }
                    finalParts.push("*." + p);
                }
                single += " (" + finalParts.join(", ") + ")|" + finalParts.join(";");
                arr.push(single);
            }
            s = arr.join("|");
            s += "|All Files (*.*)|*.*";
        }
        return s;
    }
}