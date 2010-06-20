/*
 * Represents a color component or a color group
 */
package library.hue
{
    public class HueComponent 
    {
        public static var HSL:String = 'hsl';
        public static var HSL_HUE:String = 'hslHue';
        public static var HSL_SATURATION:String = 'hslSaturation';
        public static var HSL_LIGHTNESS:String = 'hslLightness';

        public static var RGB:String = 'rgb';
        public static var RGB_RED:String = 'rgbRed';
        public static var RGB_GREEN:String = 'rgbGreen';
        public static var RGB_BLUE:String = 'rgbBlue';

        public static var XYZ:String = 'xyz';
        public static var XYZ_X:String = 'xyzX';
        public static var XYZ_Y:String = 'xyzY';
        public static var XYZ_Z:String = 'xyzZ';

        public static var LAB:String = 'lab';
        public static var LAB_L:String = 'labL';
        public static var LAB_A:String = 'labA';
        public static var LAB_B:String = 'labB';

        // Returns the group name for the specified component
        public static function getGroupForComponent(component:String):String
        {
            switch(component)
            {
                default:
                case HueComponent.HSL_HUE:
                case HueComponent.HSL_LIGHTNESS:
                case HueComponent.HSL_SATURATION:
                    return HueComponent.HSL;
                case HueComponent.RGB_RED:
                case HueComponent.RGB_GREEN:
                case HueComponent.RGB_BLUE:
                    return HueComponent.RGB;
                case HueComponent.LAB_L:
                case HueComponent.LAB_A:
                case HueComponent.LAB_B:
                    return HueComponent.LAB;
                case HueComponent.XYZ_X:
                case HueComponent.XYZ_Y:
                case HueComponent.XYZ_Z:
                    return HueComponent.XYZ;
            }
        }

        public static function getPropertyForComponent(component:String):String
        {
            switch(component)
            {
                default:
                case HSL_HUE:
                    return 'h';
                case HSL_SATURATION:
                    return 's';
                case HSL_LIGHTNESS:
                    return 'l';
    
                case RGB_RED:
                    return 'r';
                case RGB_GREEN:
                    return 'g';
                case RGB_BLUE:
                    return 'b';
    
                case XYZ_X:
                    return 'x';
                case XYZ_Y:
                    return 'y';
                case XYZ_Z:
                    return 'z';
    
                case LAB_L:
                    return 'l';
                case LAB_A:
                    return 'a';
                case LAB_B:
                    return 'b';
            }
        }
    }
}


















