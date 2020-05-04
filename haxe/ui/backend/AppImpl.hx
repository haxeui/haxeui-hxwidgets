package haxe.ui.backend;

import haxe.ui.events.AppEvent;
import hx.widgets.App;
import hx.widgets.Event;
import hx.widgets.EventType;
import hx.widgets.Frame;
import hx.widgets.PlatformInfo;
import hx.widgets.SystemMetric;
import hx.widgets.SystemOptions;
import hx.widgets.SystemSettings;
import hx.widgets.styles.WindowStyle;
import wx.widgets.styles.FrameStyle;

class AppImpl extends AppBase {
    private var _app:App;
    private var _frame:Frame;
    private var _onEnd:Void->Void;

    public function new() {
        SystemOptions.setOption("msw.window.no-clip-children", 1);
    }

    private override function build() {
        #if PLATFORM_MAC
        if (Toolkit.backendProperties.getPropBool("haxe.ui.hxwidgets.menu.autoWindowHide", true) == true) {
            wx.widgets.MenuBar.setAutoWindowMenu(false);
        }
        #end

        _app = new App();
        _app.init();

        var platform:PlatformInfo = new PlatformInfo();
        var style:Int = FrameStyle.DEFAULT_FRAME_STYLE;
        var style:Int = WindowStyle.NO_FULL_REPAINT_ON_RESIZE | WindowStyle.CLIP_CHILDREN | FrameStyle.DEFAULT_FRAME_STYLE;
        //var style:Int = WindowStyle.CLIP_CHILDREN | FrameStyle.MINIMIZE_BOX |  FrameStyle.CAPTION | FrameStyle.CLOSE_BOX;
        _frame = new Frame(null, Toolkit.backendProperties.getProp("haxe.ui.hxwidgets.frame.title", ""), style);
        if (platform.isWindows) {
            //frame.backgroundColour = 0xFFFFFF;
        }
    }

    private override function init(onReady:Void->Void, onEnd:Void->Void = null) {
        _onEnd = onEnd;
        var frameWidth:Int = Toolkit.backendProperties.getPropInt("haxe.ui.hxwidgets.frame.width", 800);
        var frameHeight:Int = Toolkit.backendProperties.getPropInt("haxe.ui.hxwidgets.frame.height", 600);

        var frameLeft:Int = 0;
        if (Toolkit.backendProperties.getProp("haxe.ui.hxwidgets.frame.left", null) == "center") {
            frameLeft = Std.int((SystemSettings.getMetric(SystemMetric.SCREEN_X) / 2) - (frameWidth / 2));
        } else {
            frameLeft = Toolkit.backendProperties.getPropInt("haxe.ui.hxwidgets.frame.left", 0);
        }

        var frameTop:Int = 0;
        if (Toolkit.backendProperties.getProp("haxe.ui.hxwidgets.frame.top", null) == "center") {
            frameTop = Std.int((SystemSettings.getMetric(SystemMetric.SCREEN_Y) / 2) - (frameHeight / 2));
        } else {
            frameTop = Toolkit.backendProperties.getPropInt("haxe.ui.hxwidgets.frame.top", 0);
        }

        _frame.freeze();
        _frame.resize(frameWidth, frameHeight);
        _frame.move(frameLeft, frameTop);

        _frame.bind(EventType.CLOSE_WINDOW, function(e:Event) {
            dispatch(new AppEvent(AppEvent.APP_CLOSED));
            _frame.destroy();
        });

        dispatch(new AppEvent(AppEvent.APP_READY));
        onReady();
    }

    private override function getToolkitInit():ToolkitOptions {
        return {
            frame: _frame
        };
    }

    public override function start() {
        if (Toolkit.backendProperties.getPropBool("haxe.ui.hxwidgets.frame.fit", false) == true) {
            Toolkit.callLater(function() {
                _frame.fit();
                _frame.center();
                _frame.show(true);
            });
        } else {
            _frame.show(true);
            _frame.center();
        }
        _frame.thaw();
        dispatch(new AppEvent(AppEvent.APP_STARTED));
        _app.run();

        _app.exit();
        if (_onEnd != null) {
            dispatch(new AppEvent(AppEvent.APP_EXITED));
            _onEnd();
        }
    }
    
    public override function exit() {
        _frame.close();
    }
}