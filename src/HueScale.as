/*
 * HueScale
 * A collection of methods for converting color values between different scales
 * 
 * License:
 * http://creativecommons.org/licenses/by-sa/3.0/
 * 
 * Created by Tedde Lundgren
 * 
 */
package src
{
  public final class HueScale
  {
  	// Actual scale as represented in Hue
  	public static var REAL:String = 'real';
  	
  	// Percentages
  	public static var PERCENTAGE:String = 'percentage';
  	
  	// Normalized to the most commonly used scale
  	public static var NORMALIZED:String = 'normalized';
  	
  	public static function getScaleForString(str:String):String
  	{
  		switch(str)
  		{
  			default:
  			case getStringForScale(REAL):
  			  return REAL;
  			case getStringForScale(PERCENTAGE):
  			  return PERCENTAGE;
  			case getStringForScale(NORMALIZED):
  			  return NORMALIZED;
  		}
  	}
  	
  	public static function getStringForScale(scale:String):String
    {
      switch(scale)
      {
      	default:
      	case REAL:
      	  return 'Real';
      	case PERCENTAGE:
      	  return 'Percentage';
      	case NORMALIZED:
      	  return 'Normalized';
      }
    }
  	
  	public static function getEnumeration():Array
  	{
  		return [getStringForScale(NORMALIZED), getStringForScale(PERCENTAGE)];
  	}
  	
  	// Gets the max and min range for the specified component, in the specified scale
  	public static function getRangeForScale(component:String, scale:String):Object
  	{
  		var obj:Object = {max: 0, min: 0};
  		
  		switch(true)
  		{
  			case component == HueComponent.LAB_L:
  			case scale == HueScale.NORMALIZED && component == HueComponent.HSL_LIGHTNESS:
        case scale == HueScale.NORMALIZED && component == HueComponent.HSL_SATURATION:
  			case scale == PERCENTAGE:
  			  obj.max = 100;
  			  obj.min = 0;
  			break;
  			
  			case component == HueComponent.LAB_A:
        case component == HueComponent.LAB_B:
          obj.max = 127;
          obj.min = -128;
        break;
        
        case component == HueComponent.HSL_HUE:
          obj.max = 360;
          obj.min = 0;
        break;
        
        case scale == HueScale.NORMALIZED && component == HueComponent.RGB:
        case scale == HueScale.NORMALIZED && component == HueComponent.RGB_RED:
        case scale == HueScale.NORMALIZED && component == HueComponent.RGB_GREEN:
        case scale == HueScale.NORMALIZED && component == HueComponent.RGB_BLUE:
          obj.max = 255;
          obj.min = 0;
        break;
        
        case component == HueComponent.XYZ_X:
          obj.max = Hue.XW;
          obj.min = 0;
        break;
        case component == HueComponent.XYZ_Y:
          obj.max = Hue.YW;
          obj.min = 0;
        break;
        case component == HueComponent.XYZ_Z:
          obj.max = Hue.ZW;
          obj.min = 0;
        break;
        
        case scale == HueScale.REAL && component == HueComponent.HSL_LIGHTNESS:
        case scale == HueScale.REAL && component == HueComponent.HSL_SATURATION:
        case scale == HueScale.REAL && component == HueComponent.RGB:
        case scale == HueScale.REAL && component == HueComponent.RGB_RED:
        case scale == HueScale.REAL && component == HueComponent.RGB_GREEN:
        case scale == HueScale.REAL && component == HueComponent.RGB_BLUE:
          obj.max = 1;
          obj.min = 0;
        break;
  		}
  		
      return obj;
  	}
  	
  	public static function scaleIsInteger(scale:String):Boolean
  	{
  		return scale == REAL ? false : true;
  	}
  	
  	// Converts the specified component value to a scale defined in Hue options
  	public static function fromHue(value:Number, component:String, color:Hue):Number
  	{
  		var scale:String = color.options.getScale(component);
  		return fromReal(scale, component, value);
    }

    // Converts the specified component value (from scale corresponding to Hue options) to the real scale
  	public static function toHue(value:Number, component:String, color:Hue):Number
  	{
  		var scale:String = color.options.getScale(component);
      return toReal(scale, component, value);
  	}
  	
  	// Converts the specified component of a certain value, to the specified scale
  	public static function fromReal(scale:String, component:String, value:Number):Number
  	{
  		var fromRange:Object = getRangeForScale(component, REAL);
  		var toRange:Object = getRangeForScale(component, scale);
  		var a:Number = change(value, fromRange.min, fromRange.max, toRange.min, toRange.max);
  		return scaleIsInteger(scale) ? Math.round(a) : a;
    }

    // Converts a value of the specified scale to the real scale for the specified component
    public static function toReal(scale:String, component:String, value:Number):Number
  	{
  		var fromRange:Object = getRangeForScale(component, scale);
  		var toRange:Object = getRangeForScale(component, REAL);
  		var a:Number = change(value, fromRange.min, fromRange.max, toRange.min, toRange.max);
  		a = HuePrecision.truncateValue(a, toRange.min, toRange.max);
      return a;
  	}
  	
  	// Linearly changes the value x, which is in the a1 and b1 interval, to be in the a2 and b2 interval
  	public static function change(x:Number, a1:Number, b1:Number, a2:Number = 0, b2:Number = 1):Number
  	{
      return (x * (a2 - b2) + a1 * b2 - a2 * b1) / (a1 - b1);
  	}
  }
}








