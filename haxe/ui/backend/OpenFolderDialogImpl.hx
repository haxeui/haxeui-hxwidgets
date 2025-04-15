package haxe.ui.backend;

import haxe.io.Path;
import haxe.ui.backend.OpenFolderDialogBase;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.core.Screen;
import hx.widgets.DirDialog;
import hx.widgets.StandardId;
import hx.widgets.styles.DirDialogStyle;
import sys.io.File;

using StringTools;

class OpenFolderDialogImpl extends OpenFolderDialogBase {
    public override function show() {
        var message = options.title;
        if (message == null) {
            message = "Open Folder";
        }
        var defaultPath = options.defaultPath;
        var style = DirDialogStyle.DEFAULT_STYLE;
        if (options.multiple) {
            #if (wxWidgetsVersion >= version("3.1.4")) 
            style |= DirDialogStyle.MULTIPLE;
            #end
        }
        if (options.hiddenFolders) {
            #if (wxWidgetsVersion >= version("3.1.4")) 
            style |= DirDialogStyle.SHOW_HIDDEN;
            #end
        }
        if (options.canCreateFolder) {
            style |= DirDialogStyle.DIR_MUST_EXIST;
        }
        var nativeDialog = new DirDialog(Screen.instance.frame, message, defaultPath, style);
        var r = nativeDialog.showModal();
        if (r == StandardId.OK) {
            var infos:Array<String> = [];
            for (path in nativeDialog.paths) {
                infos.push(path);
            }
            dialogConfirmed(infos);
        } else {
            dialogCancelled();
        }
    }
}