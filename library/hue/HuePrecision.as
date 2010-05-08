/*
 * HuePrecision
 * A collection of methods for manipulating the precision of a color group
 * 
 * License:
 * http://creativecommons.org/licenses/by-sa/3.0/
 * 
 * Created by Tedde Lundgren
 * 
 */
package library.hue
{
  public final class HuePrecision 
  {
  	// Bits per pixel
  	public static const BPP8:uint = 256;
  	public static const BPP7:uint = 128;
  	public static const BPP6:uint = 64;
  	public static const BPP5:uint = 32;
  	public static const BPP4:uint = 16;
  	
  	// Returns available precision options as an enumerated array
  	public static function getEnumeration():Array
  	{
  		return [getStringForPrecision(BPP8), getStringForPrecision(BPP5), getStringForPrecision(BPP4)];
  	}
  	
  	public static function getStringForPrecision(precision:uint):String
  	{
  		switch(precision)
  		{
  			default:
  			case BPP8:
  			  return 'Real (256)';
  			case BPP5:
  			  return '32';
  			case BPP4:
  			  return '16';
  		}
  	}
  	
  	public static function getPrecisionForString(value:String):uint
  	{
      switch(value)
      {
        default:
        case getStringForPrecision(BPP8):
          return BPP8;
        case getStringForPrecision(BPP5):
          return BPP5;
        case getStringForPrecision(BPP4):
          return BPP4;
      }
  	}
  	
  	// Changes the precision of value
    public static function change(precision:uint, value:Number, min:Number = 0, max:Number = 1):Number
    {
      var tv:Number = HueScale.change(value, min, max, 0, precision - 1);
      tv = Math.round(tv);
      return HueScale.change(tv, 0, precision - 1, min, max);
    }
  	
  	// Truncates values higher than max or lower than min to max and min respectively
  	public static function truncateValue(value:Number, min:Number, max:Number):Number
  	{
  		return (value <= min) ? min : (value >= max ? max : value);
  	}
  	
  	// Changes the precision of a color group
  	public static function changeGroup(group:String, values:Object, precision:uint):Object
  	{
  		switch(group)
  		{
  			default:
  			case HueComponent.RGB:
    			var rgb:Object = {};
          rgb.r = change(precision, values.r);
          rgb.g = change(precision, values.g);
          rgb.b = change(precision, values.b);
          return rgb;
  			break;
  			case HueComponent.LAB:
          var lab:Object = {};
          lab.l = change(precision, values.l, 0, 100);
          lab.a = change(precision, values.a, -128, 127);
          lab.b = change(precision, values.b, -128, 127);
          return lab;
        break;
        case HueComponent.XYZ:
          var xyz:Object = {};
          xyz.x = change(precision, values.x, 0, Hue.XW);
          xyz.y = change(precision, values.y, 0, Hue.YW);
          xyz.z = change(precision, values.z, 0, Hue.ZW);
          return xyz;
        break;
        case HueComponent.HSL:
          var hsl:Object = {};
          hsl.h = change(precision, values.h, 0, 360);
          hsl.s = change(precision, values.s);
          hsl.l = change(precision, values.l);
          return hsl;
        break;
  		}
  	}
  	
  	// Changes the precision of an RGB object
  	public static function changeRGB(precision:uint, rgb:Object):Object
  	{
  		var trgb:Object = {};
  		trgb.r = change(precision, rgb.r);
  		trgb.g = change(precision, rgb.g);
  		trgb.b = change(precision, rgb.b);
  		return trgb;
  	}
  	
  	// Truncate the lab object to values that are within most commonly used range
  	public static function truncateLAB(lab:Object):Object
  	{
  		var tlab:Object = {};
      
      tlab.l = truncateValue(lab.l, 0, 100);
      tlab.a = truncateValue(lab.a, -128, 127);
      tlab.b = truncateValue(lab.b, -128, 127);
      
      return tlab;
  	}
  	
  	// Truncates the HSL object to values that are within commonly used range
  	public static function truncateHSL(hsl:Object):Object
  	{
  		var thsl:Object = {};
      
      thsl.h = truncateValue(hsl.h, 0, 360);
      thsl.s = truncateValue(hsl.s, 0, 1);
      thsl.l = truncateValue(hsl.l, 0, 1);
      
      return thsl;
  	}
  	
  	// Truncate the RGB object to values that represent visible colors
  	public static function truncateRGB(rgb:Object):Object
  	{
  		var trgb:Object = {};
  		
  		trgb.r = (rgb.r <= 0) ? 0 : (rgb.r >= 1 ? 1 : rgb.r);
  		trgb.g = (rgb.g <= 0) ? 0 : (rgb.g >= 1 ? 1 : rgb.g);
      trgb.b = (rgb.b <= 0) ? 0 : (rgb.b >= 1 ? 1 : rgb.b);
  		
  		return trgb;
  	}
  	
  	// Truncate the XYZ object that are within commonly used range (0 -> reference white component maximum)
  	public static function truncateXYZ(xyz:Object):Object
    {
      var txyz:Object = {};
      
      txyz.x = (xyz.x <= 0) ? 0 : (xyz.x >= Hue.XW ? Hue.XW : xyz.x);
      txyz.y = (xyz.y <= 0) ? 0 : (xyz.y >= Hue.YW ? Hue.YW : xyz.y);
      txyz.z = (xyz.z <= 0) ? 0 : (xyz.z >= Hue.ZW ? Hue.ZW : xyz.z);
      
      return txyz;
    }
  }
}
