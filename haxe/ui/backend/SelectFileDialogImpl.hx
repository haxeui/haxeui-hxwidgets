package haxe.ui.backend;

import haxe.io.Path;
import haxe.ui.backend.SelectFileDialogBase;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.core.Screen;
import hx.widgets.FileDialog;
import hx.widgets.StandardId;
import sys.io.File;

class SelectFileDialogImpl extends SelectFileDialogBase {
    public override function show() {
        validateOptions();
        var message = "Select File";
        var pattern = "All(*.*)|*.*";
        var nativeDialog = new FileDialog(Screen.instance.frame, message, null, null, pattern);
        var r = nativeDialog.showModal();
        if (r == StandardId.OK) {
            var infos:Array<SelectedFileInfo> = [];
            infos.push({
                name: nativeDialog.filename,
                fullPath: Path.normalize(nativeDialog.directory + "/" + nativeDialog.filename),
                isBinary: false
            });
            
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
            
            if (callback != null) {
                callback(DialogButton.OK, infos);
            }
        } else {
            if (callback != null) {
                callback(DialogButton.CANCEL, null);
            }
        }
    }
}