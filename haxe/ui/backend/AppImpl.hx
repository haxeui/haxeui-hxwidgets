package haxe.ui.backend;

import haxe.ui.ToolkitAssets;
import haxe.ui.core.Screen;
import haxe.ui.events.AppEvent;
import hx.widgets.App;
import hx.widgets.Bitmap;
import hx.widgets.Event;
import hx.widgets.EventType;
import hx.widgets.Frame;
import hx.widgets.Icon;
import hx.widgets.IdleEvent;
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
    private var __onEnd:Void->Void;

    #if (haxe_ver >= 4.2)
    private static var mainThread:sys.thread.Thread;
    public static var targetFramerate:Int = 60;
    private static var targetFrameMS:Int = 0;
    #end

    public function new() {
        //SystemOptions.setOption("msw.window.no-clip-children", 1);
        // seems interesting - https://docs.wxwidgets.org/trunk/classwx_system_options.html
        //SystemOptions.setOption("msw.dark-mode", 1);
        #if (haxe_ver >= 4.2)
        untyped __cpp__("wxIdleEvent::SetMode(wxIDLE_PROCESS_SPECIFIED)");
        mainThread = sys.thread.Thread.current();
        #end
        #if (haxeui_hxwidgets_use_idle_event && haxe_ver >= 4.2)
        targetFrameMS = Std.int(1000 / targetFramerate);
        #end
    }

    private override function build() {
        #if PLATFORM_MAC
        if (Toolkit.backendProperties.getPropBool("haxe.ui.hxwidgets.menu.autoWindowHide", true) == true) {
            wx.widgets.MenuBar.setAutoWindowMenu(false);
        }
        #end

        _app = new App();
        #if (haxeui_hxwidgets_use_idle_event && haxe_ver >= 4.2)
        _app.bind(EventType.IDLE, onIdle);
        #end
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

    #if (haxeui_hxwidgets_use_idle_event && haxe_ver >= 4.2)
    var lastFrame:Float = Date.now().getTime();
    private function onIdle(event:Event) {
        if (_closed) {
            return;
        }

        endTimer();
        var currentFrame = Date.now().getTime();
        var delta = currentFrame - lastFrame;
        if (delta >= targetFrameMS) {
            lastFrame = currentFrame;
            mainThread.events.progress();
        }
        var idleEvent = event.convertTo(IdleEvent);
        idleEvent.requestMore();
    }
    #end

    #if (haxe_ver >= 4.2)

    var firstResize = true;
    // were going to work around an edge case: in wx widgets, idle events arent send when the app frame is resizing or
    // moving, what we are going to do in these cases is use a timer to update the haxe event loop at 60fps, once we 
    // start receiving idle events again, we can assume as is good and shutdown the timer
    private function onResize(event:Event) {
        if (firstResize) { // not sure this needs to happens twice
            firstResize = false;
            mainThread.events.progress();
            mainThread.events.progress();
        }
        startTimer();
    }

    private function onMove(event:Event) {
        startTimer();
    }

    var _timer:haxe.ui.util.Timer = null;
    private inline function startTimer() {
        if (_timer != null) {
            return;
        }

        mainThread.events.progress();
        _timer = new haxe.ui.util.Timer(targetFrameMS, onTimer);
    }

    private inline function endTimer() {
        if (_timer == null) {
            return;
        }

        _timer.stop();
        _timer = null;
    }

    private inline function onTimer() {
        mainThread.events.progress();
    }
    #end

    private override function init(onReady:Void->Void, onEnd:Void->Void = null) {
        __onEnd = onEnd;
        
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

        #if (haxe_ver >= 4.2)
        _frame.bind(EventType.SIZE, onResize);
        _frame.bind(EventType.MOVE, onMove);
        #end
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
            @:privateAccess Timer.stopAll();

            dispatch(new AppEvent(AppEvent.APP_CLOSED));
            #if (haxeui_hxwidgets_use_idle_event && haxe_ver >= 4.2)
            _app.unbind(EventType.IDLE, onIdle);
            #end

            #if (haxe_ver >= 4.2)
            endTimer();
            _frame.unbind(EventType.SIZE, onResize);
            _frame.unbind(EventType.MOVE, onMove);
            #end
            _frame.destroy();
            Sys.exit(0); // lets explicitly exit since we dont care about any pending event anymore
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
        if (_frame.menuBar != null) {
            _frame.menuBar.show();
        }
        dispatch(new AppEvent(AppEvent.APP_STARTED));
        @:privateAccess TimerImpl.processDeferredTimers();
        _app.run();

        _app.exit();
        dispatch(new AppEvent(AppEvent.APP_EXITED));
        if (__onEnd != null) {
            __onEnd();
        }
    }
    
    public override function exit() {
        _frame.close();
    }
    
    private var _cachedIcon:Map<Bitmap, Icon> = new Map<Bitmap, Icon>();
    private override function set_icon(value:String):String {
        if (_icon == value) {
            return value;
        }
        _icon = value;
        var frame = Screen.instance.frame;
        ToolkitAssets.instance.getImage(value, function(imageInfo) {
            if (imageInfo != null) {
                var bitmap:Bitmap = imageInfo.data;
                var icon = _cachedIcon.get(bitmap);
                if (icon == null) {
                    icon = new Icon();
                    icon.copyFromBitmap(imageInfo.data);
                    _cachedIcon.set(bitmap, icon);
                }
                frame.setIcon(icon);
            }
        });
        return value;
    }
}
