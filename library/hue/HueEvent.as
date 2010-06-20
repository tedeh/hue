/*
 * HueEvent
 * Events dispatched by Hue
 * 
 * License:
 * http://creativecommons.org/licenses/by-sa/3.0/
 * 
 * Created by Tedde Lundgren
 * 
 */
package library.hue
{
    import flash.events.Event;  

    public class HueEvent extends Event 
    {
        // Signals that the color of Hue has changed
        public static const CHANGE:String = 'change';

        // Precision has changed
        public static const PRECISION_CHANGE:String = 'precisionChange';

        // Scale has changed
        public static const SCALE_CHANGE:String = 'scaleChange';

        public var hue:Hue;

        public function HueEvent(type:String, hue:Hue)
        {
            super(type, true, false);
            this.hue = hue;
        }
    }
}
