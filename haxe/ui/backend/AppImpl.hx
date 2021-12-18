package haxe.ui.backend;

import haxe.ui.core.Screen;
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

/*
* haxe.ui.hxwidgets.frame.fit=boolean will reszie the top level frame to the contents of the UI
* haxe.ui.hxwidgets.frame.title=string just the title of the frame, you dont have to set it here, but its an easy way.
* haxe.ui.hxwidgets.frame.width=number the default width of the main frame (800 if not set), note, this property is ignored if haxe.ui.hxwidgets.frame.fit=true
* haxe.ui.hxwidgets.frame.height=number the default height of the main frame (600 if not set), note, this property is ignored if haxe.ui.hxwidgets.frame.fit=true
* haxe.ui.hxwidgets.frame.minWidth=number the minimum width of the main frame (-1 if not set)
* haxe.ui.hxwidgets.frame.minHeight=number the minimum height of the main frame (-1 if not set)
* haxe.ui.hxwidgets.frame.maxWidth=number the maximum width of the main frame (-1 if not set)
* haxe.ui.hxwidgets.frame.maxHeight=number the maximum height of the main frame (-1 if not set)
* haxe.ui.hxwidgets.frame.left=number the position of frame (x axis) defaults to center screen
* haxe.ui.hxwidgets.frame.top=number the position of frame (y axis) defaults to center screen
* haxe.ui.hxwidgets.frame.maximized=boolean whether to start the frame is a maximized state
* haxe.ui.hxwidgets.frame.maximizable=boolean
* haxe.ui.hxwidgets.frame.minimizable=boolean
* haxe.ui.hxwidgets.frame.closeable=boolean
* haxe.ui.hxwidgets.frame.resizable=boolean
*/
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
        var style:Int = WindowStyle.NO_FULL_REPAINT_ON_RESIZE | WindowStyle.CLIP_CHILDREN | FrameStyle.DEFAULT_FRAME_STYLE;
        if (Toolkit.backendProperties.getPropBool("haxe.ui.hxwidgets.frame.maximizable", true) == false) {
            style ^= FrameStyle.MAXIMIZE_BOX;
        }
        if (Toolkit.backendProperties.getPropBool("haxe.ui.hxwidgets.frame.minimizable", true) == false) {
            style ^= FrameStyle.MINIMIZE_BOX;
        }
        if (Toolkit.backendProperties.getPropBool("haxe.ui.hxwidgets.frame.closeable", true) == false) {
            style ^= FrameStyle.CLOSE_BOX;
        }
        if (Toolkit.backendProperties.getPropBool("haxe.ui.hxwidgets.frame.resizable", true) == false) {
            style ^= FrameStyle.RESIZE_BORDER;
        }
        _frame = new Frame(null, Toolkit.backendProperties.getProp("haxe.ui.hxwidgets.frame.title", ""), style);
        if (platform.isWindows) {
            //frame.backgroundColour = 0xFFFFFF;
        }
    }

    private override function init(onReady:Void->Void, onEnd:Void->Void = null) {
        _onEnd = onEnd;
        
        var maximized:Bool = Toolkit.backendProperties.getPropBool("haxe.ui.hxwidgets.frame.maximized", false);
        var frameWidth:Int = Toolkit.backendProperties.getPropInt("haxe.ui.hxwidgets.frame.width", 800);
        var frameHeight:Int = Toolkit.backendProperties.getPropInt("haxe.ui.hxwidgets.frame.height", 600);
        var frameMinWidth:Int = Toolkit.backendProperties.getPropInt("haxe.ui.hxwidgets.frame.minWidth", -1);
        var frameMinHeight:Int = Toolkit.backendProperties.getPropInt("haxe.ui.hxwidgets.frame.minHeight", -1);
        var frameMaxWidth:Int = Toolkit.backendProperties.getPropInt("haxe.ui.hxwidgets.frame.maxWidth", -1);
        var frameMaxHeight:Int = Toolkit.backendProperties.getPropInt("haxe.ui.hxwidgets.frame.maxHeight", -1);

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
        if (maximized == true) {
            _frame.maximize(true);
        } else {
            _frame.resize(frameWidth, frameHeight);
            _frame.move(frameLeft, frameTop);
        }
        
        _frame.minSize = new hx.widgets.Size(frameMinWidth, frameMinHeight);
        _frame.maxSize = new hx.widgets.Size(frameMaxWidth, frameMaxHeight);

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
        var hasPercentWidth = false;
        var hasPercentHeight = false;
        if (Screen.instance.rootComponents.length > 0) {
            for (c in Screen.instance.rootComponents) {
                if (c.percentWidth != null) {
                    hasPercentWidth = true;
                }
                if (c.percentHeight != null) {
                    hasPercentHeight = true;
                }
            }
        }

        var defaultFit = true;
        if (hasPercentWidth == true && hasPercentHeight == true) {
            defaultFit = false;
        }
        var fit = Toolkit.backendProperties.getPropBool("haxe.ui.hxwidgets.frame.fit", defaultFit);
        
        if (fit == true) {
            Toolkit.callLater(function() {
                var children = _frame.children;
                // from wx docs:
                // if the window has exactly one subwindow it is better (faster and the
                // result is more precise as Fit() adds some margin to account for fuzziness
                // of its calculations) to call: window->SetClientSize(child->GetSize());
                if (children.length == 1) {
                    _frame.clientSize = children[0].size;
                } else {
                    _frame.fit();
                }
                _frame.center();
                _frame.show(true);
            });
        } else {
            _frame.show(true);
            _frame.center();
        }
        _frame.thaw();
        dispatch(new AppEvent(AppEvent.APP_STARTED));
        @:privateAccess TimerImpl.processDeferredTimers();
        _app.run();

        _app.exit();
        dispatch(new AppEvent(AppEvent.APP_EXITED));
        if (_onEnd != null) {
            _onEnd();
        }
    }
    
    public override function exit() {
        _frame.close();
    }
}