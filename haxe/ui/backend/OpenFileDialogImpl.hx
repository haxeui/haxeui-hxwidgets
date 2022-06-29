package haxe.ui.backend;

import haxe.io.Path;
import haxe.ui.backend.OpenFileDialogBase;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.containers.dialogs.Dialogs.SelectedFileInfo;
import haxe.ui.core.Screen;
import hx.widgets.FileDialog;
import hx.widgets.StandardId;
import hx.widgets.styles.FileDialogStyle;
import sys.io.File;

using StringTools;

class OpenFileDialogImpl extends OpenFileDialogBase {
    public override function show() {
        var message = options.title;
        if (message == null) {
            message = "Open File";
        }
        var pattern = buildPattern();
        var style = FileDialogStyle.OPEN | FileDialogStyle.FILE_MUST_EXIST;
        if (options.multiple) {
            style |= FileDialogStyle.MULTIPLE;
        }
        var nativeDialog = new FileDialog(Screen.instance.frame, message, null, null, pattern, style);
        var r = nativeDialog.showModal();
        if (r == StandardId.OK) {
            var infos:Array<SelectedFileInfo> = [];
            for (filename in nativeDialog.filenames) {
                infos.push({
                    name: filename,
                    fullPath: Path.normalize(nativeDialog.directory + "/" + filename),
                    isBinary: false
                });
            }
            
            if (options.readContents == true) {
                for (info in infos) {
                    if (options.readAsBinary) {
                        info.isBinary = true;
                        info.bytes = File.getBytes(info.fullPath);
                    } else {
                        info.isBinary = false;
                        info.text = File.getContent(info.fullPath);
                    }
                }
            }
            
            dialogConfirmed(infos);
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