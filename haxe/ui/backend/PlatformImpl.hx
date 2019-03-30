package haxe.ui.backend;

import haxe.ui.core.Platform;
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
}