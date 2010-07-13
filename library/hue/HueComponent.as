/*
 * Represents a color component or a color group
 */
package library.hue
{
  public class HueComponent 
  {
    public static const HSL:String = 'hsl';
    public static const HSL_HUE:String = 'hslHue';
    public static const HSL_SATURATION:String = 'hslSaturation';
    public static const HSL_LIGHTNESS:String = 'hslLightness';

    public static const RGB:String = 'rgb';
    public static const RGB_RED:String = 'rgbRed';
    public static const RGB_GREEN:String = 'rgbGreen';
    public static const RGB_BLUE:String = 'rgbBlue';

    public static const XYZ:String = 'xyz';
    public static const XYZ_X:String = 'xyzX';
    public static const XYZ_Y:String = 'xyzY';
    public static const XYZ_Z:String = 'xyzZ';

    public static const LAB:String = 'lab';
    public static const LAB_L:String = 'labL';
    public static const LAB_A:String = 'labA';
    public static const LAB_B:String = 'labB';

    // Returns the group name for the specified component
    public static function getGroupForComponent(component:String):String
    {
      switch(component)
      {
      default:
        throw new ArgumentError(component + " is not a valid component");
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
        throw new ArgumentError(component + " is not a valid component");
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


















