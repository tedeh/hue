/*
 * HueOptions
 * Holds options that belong to a defined Hue object
 * Provides a interface for changing global scale and precision objects
 * 
 * License:
 * http://creativecommons.org/licenses/by-sa/3.0/
 * 
 * Created by Tedde Lundgren
 * 
 */
package library.hue
{
  public final class HueOptions
  {
    private var currentHue:Hue;
    private var currentPrecision:uint = HuePrecision.BPP8;
    
    private var rgbScale:String = HueScale.NORMALIZED;
  	private var xyzScale:String = HueScale.REAL;
  	private var hslScale:String = HueScale.NORMALIZED;
  	private var labScale:String = HueScale.NORMALIZED;
  	
  	public function set hue(h:Hue):void
    {
      currentHue = h;
    }
    
    public function get hue():Hue
    {
      return currentHue;
    }

    public function get precision():uint
    {
      return currentPrecision;
    }

    public function set precision(precision:uint):void
    {
      currentPrecision = precision;
      currentHue.notifyPrecisionChange();
    }

    public function getScale(identifier:String):String
  	{
  		switch(identifier)
  		{
  			case HueComponent.RGB_RED:
  			case HueComponent.RGB_GREEN:
  			case HueComponent.RGB_BLUE:
  			case HueComponent.RGB:
  			  return rgbScale;
  			case HueComponent.HSL_HUE:
  			case HueComponent.HSL_SATURATION:
  			case HueComponent.HSL_LIGHTNESS:
  			case HueComponent.HSL:
          return hslScale;
        case HueComponent.XYZ_X:
        case HueComponent.XYZ_Y:
        case HueComponent.XYZ_Z:
        case HueComponent.XYZ:
          return xyzScale;
        case HueComponent.LAB_L:
        case HueComponent.LAB_A:
        case HueComponent.LAB_B:
        case HueComponent.LAB:
          return labScale;
      }
    }
    
    public function setAllScales(scale:String):void
    {
    	rgbScale = scale;
    	hslScale = scale;
    	labScale = scale;
    	currentHue.notifyScaleChange();
    }
  	
  	public function setScale(identifier:String, scale:String):void
  	{
  		switch(identifier)
      {
        case HueComponent.RGB_RED:
        case HueComponent.RGB_GREEN:
        case HueComponent.RGB_BLUE:
        case HueComponent.RGB:
          rgbScale = scale;
        break;
        case HueComponent.HSL_HUE:
        case HueComponent.HSL_SATURATION:
        case HueComponent.HSL_LIGHTNESS:
        case HueComponent.HSL:
          hslScale = scale;
        break;
        case HueComponent.XYZ_X:
        case HueComponent.XYZ_Y:
        case HueComponent.XYZ_Z:
        case HueComponent.XYZ:
          xyzScale = scale;
        break;
        case HueComponent.LAB_L:
        case HueComponent.LAB_A:
        case HueComponent.LAB_B:
        case HueComponent.LAB:
          labScale = scale;
        break;
      }
      currentHue.notifyScaleChange();
    }
  }
}















