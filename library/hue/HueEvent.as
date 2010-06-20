/*
 * Event class used by Hue
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
