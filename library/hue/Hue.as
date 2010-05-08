 /*
 * Hue
 * Represents a color, and gives a common interface for the manipulation of it
 * 
 * License:
 * http://creativecommons.org/licenses/by-sa/3.0/
 * 
 * Created by Tedde Lundgren
 * 
 */
package library.hue
{
  import flash.events.EventDispatcher;
  import flash.utils.ByteArray;
  
  import fl.motion.DynamicMatrix; 

  public class Hue extends EventDispatcher
  {
    // Options
    public var options:HueOptions;
    
    // CIE Standard
    public static const E:Number = 216 / 24389;
    public static const K:Number = 24389 / 27;
    
    // Reference white (D65)
    public static const XW:Number = 0.95047;
    public static const YW:Number = 1.0000001;
    public static const ZW:Number = 1.088830;
    
    // Stores the components
    private var components:Object = {
      xyz: {x: 0, y: 0, z: 0}, rgb: {r: 0, g: 0, b: 0}, lab: {l: 0, a: 0, b: 0}, hsl: {h: 0, s: 0, l: 0}
    };
    
    public function Hue(options:HueOptions)
    {
      this.options = options;
      this.options.hue = this;
    }
    
    private function set hsl(hsl:Object):void
    {
    	if(!isNaN(hsl.h))
    	{
    		components.hsl.h = hsl.h;
    	}

      components.hsl.s = hsl.s;
    	components.hsl.l = hsl.l;
    }
    
    private function set rgb(rgb:Object):void
    {
    	components.rgb = rgb;
    }
    
    private function set xyz(xyz:Object):void
    {
    	components.xyz = xyz;
    }
    
    private function set lab(lab:Object):void
    {
    	components.lab = lab;
    }

    // Dispatches the HueEvent.CHANGE event
    public function notifyChange():void
    {
      var e:HueEvent = new HueEvent(HueEvent.CHANGE, this);
      dispatchEvent(e);
    }
    
    // Dispatches the HueEvent.SCALE_CHANGE event
    public function notifyScaleChange():void
    {
      var e:HueEvent = new HueEvent(HueEvent.SCALE_CHANGE, this);
      dispatchEvent(e);
    }
    
    // Dispatches the HueEvent.PRECISION_CHANGE event
    public function notifyPrecisionChange():void
    {
      var e:HueEvent = new HueEvent(HueEvent.PRECISION_CHANGE, this);
      dispatchEvent(e);
    }
    
    // Returns a single component
    public function getComponent(component:String):Number
    {
      switch(component)
      {
        default:
        case HueComponent.HSL_HUE:
          return components.hsl.h;
        case HueComponent.HSL_LIGHTNESS:
          return components.hsl.l;
        case HueComponent.HSL_SATURATION:
          return components.hsl.s;
        case HueComponent.RGB_RED:
          return components.rgb.r;
        case HueComponent.RGB_GREEN:
          return components.rgb.g;
        case HueComponent.RGB_BLUE:
          return components.rgb.b;
        case HueComponent.LAB_L:
          return components.lab.l;
        case HueComponent.LAB_A:
          return components.lab.a;
        case HueComponent.LAB_B:
          return components.lab.b;
        case HueComponent.XYZ_X:
          return components.xyz.x;
        case HueComponent.XYZ_Y:
          return components.xyz.y;
        case HueComponent.XYZ_Z:
          return components.xyz.z;
      }
    }
    
    // Sets a component to a value
    public function setComponent(component:String, value:Number, silent:Boolean = false):void
    {
      var groupName:String = HueComponent.getGroupForComponent(component);
      var group:Object = getGroup(groupName);
      switch(component)
      {
        case HueComponent.HSL_HUE:
          group.h = value;
          break;
        case HueComponent.HSL_LIGHTNESS:
          group.l = value;
          break;
        case HueComponent.HSL_SATURATION:
          group.s = value;
          break;
        case HueComponent.RGB_RED:
          group.r = value;
          break;
        case HueComponent.RGB_GREEN:
          group.g = value;
          break;
        case HueComponent.RGB_BLUE:
          group.b = value;
          break;
        case HueComponent.LAB_L:
          group.l = value;
          break;
        case HueComponent.LAB_A:
          group.a = value;
          break;
        case HueComponent.LAB_B:
          group.b = value;
          break;
        case HueComponent.XYZ_X:
          group.x = value;
          break;
        case HueComponent.XYZ_Y:
          group.y = value;
          break;
        case HueComponent.XYZ_Z:
          group.z = value;
          break;  
      }
      setGroup(groupName, group, silent);
    }

    // Returns the group specified
    public function getGroup(group:String):Object
    {
      switch(group)
      {
        default:
        case HueComponent.HSL:
          return components.hsl;
        case HueComponent.RGB:
          return components.rgb;
        case HueComponent.LAB:
          return components.lab;
        case HueComponent.XYZ:
          return components.xyz;
      }
    }
    
    // Copies passed object
    public static function copyObject(o:Object):Object
    {
      var buffer:ByteArray = new ByteArray;
      buffer.writeObject(o);
      buffer.position = 0;
      return buffer.readObject();
    }
    
    // Returns a copy of the specified group object
    public function getGroupCopy(group:String):Object
    {
      return copyObject(getGroup(group));
    }
    
    // Sets a group, and notifies the change
    public function setGroup(group:String, values:Object, silent:Boolean = false):void
    {
      switch(group)
      {
        case HueComponent.HSL:
          components.hsl = values;
          components.rgb = convertHSLToRGB(components.hsl, true);
          components.xyz = convertRGBToXYZ(components.rgb);
          components.lab = convertXYZToLAB(components.xyz);
        break;
        case HueComponent.RGB:
          components.rgb = values;
          hsl = convertRGBToHSL(components.rgb);
          components.xyz = convertRGBToXYZ(components.rgb);
          components.lab = convertXYZToLAB(components.xyz);
        break;
        case HueComponent.LAB:
          components.lab = values;
          components.xyz = convertLABToXYZ(components.lab);
          components.rgb = convertXYZToRGB(components.xyz, true);
          hsl = convertRGBToHSL(components.rgb);
        break;
        case HueComponent.XYZ:
          components.xyz = values;
          components.lab = convertXYZToLAB(components.xyz);
          components.rgb = convertXYZToRGB(components.xyz, true);
          hsl = convertRGBToHSL(components.rgb);
        break;
      }
      
      if(!silent)
      {
      	notifyChange();
      }
    }
    
    // Convert the specified rgb object to hex
    public static function convertRGBToHex(rgb:Object):Number
    {
      return rgb.r * 255 << 16 ^ rgb.g * 255 << 8 ^ rgb.b * 255;
    }
    
    // Converts the specified hex number to an rgb object
    public static function convertHexToRGB(hex:Number):Object
    {
      var rgb:Object = {r: 0, g: 0, b: 0};
      
      rgb.r = ((hex & 0xff0000) >> 16) / 255;
      rgb.g = ((hex & 0x00ff00) >> 8) / 255;
      rgb.b = (hex & 0x0000ff) / 255;
      
      return rgb;
    }
    
    // Performs a LAB to Hex conversion
    public static function convertLABToHex(lab:Object, truncateInvisibleColors:Boolean = false):Number
    {
      var fx:Number, 
          fy:Number, 
          fz:Number, 
          xr:Number, 
          yr:Number, 
          zr:Number, 
          r:Number, 
          g:Number, 
          b:Number, 
          rgb:Object = {r: 0, g: 0, b: 0}, 
          xyz:Object = {x: 0, y: 0, z: 0};
      
      fy = (lab.l + 16) / 116;
      fz = fy - (lab.b / 200);
      fx = lab.a / 500 + fy;
      
      xr = Math.pow(fx, 3) <= E ? (116 * fx - 16) / K : Math.pow(fx, 3);
      yr = lab.l > K * E ? Math.pow((lab.l + 16) / 116, 3) : lab.l / K;
      zr = Math.pow(fz, 3) <= E ? (116 * fz - 16) / K : Math.pow(fz, 3);
      
      xyz.x = xr * XW;
      xyz.y = yr * YW;
      xyz.z = zr * ZW;

      r = xyz.x * 3.2404542 + xyz.y * -1.5371385 + xyz.z * -0.4985314;
      g = xyz.x * -0.9692660 + xyz.y * 1.8760108 + xyz.z * 0.0415560;
      b = xyz.x * 0.0556434 + xyz.y * -0.2040259 + xyz.z * 1.0572252;
      
      rgb.r = r <= 0.0031308 ? 12.92 * r : 1.055 * Math.pow(r, 1 / 2.4) - 0.055;
      rgb.g = g <= 0.0031308 ? 12.92 * g : 1.055 * Math.pow(g, 1 / 2.4) - 0.055;
      rgb.b = b <= 0.0031308 ? 12.92 * b : 1.055 * Math.pow(b, 1 / 2.4) - 0.055;
      
      if(truncateInvisibleColors)
      {
        rgb.r = (rgb.r <= 0) ? 0 : (rgb.r >= 1 ? 1 : Math.round(rgb.r * 255) / 255);
        rgb.g = (rgb.g <= 0) ? 0 : (rgb.g >= 1 ? 1 : Math.round(rgb.g * 255) / 255);
        rgb.b = (rgb.b <= 0) ? 0 : (rgb.b >= 1 ? 1 : Math.round(rgb.b * 255) / 255);
      }
      
      return rgb.r * 255 << 16 ^ rgb.g * 255 << 8 ^ rgb.b * 255;
    }
    
    // Performs a XYZ to Hex conversion
    public static function convertXYZToHex(xyz:Object, truncateInvisibleColors:Boolean = false):Number
    {
    	var r:Number, 
          g:Number, 
          b:Number, 
          rgb:Object = {r: 0, g: 0, b: 0};
    	
    	r = xyz.x * 3.2404542 + xyz.y * -1.5371385 + xyz.z * -0.4985314;
      g = xyz.x * -0.9692660 + xyz.y * 1.8760108 + xyz.z * 0.0415560;
      b = xyz.x * 0.0556434 + xyz.y * -0.2040259 + xyz.z * 1.0572252;
      
      rgb.r = r <= 0.0031308 ? 12.92 * r : 1.055 * Math.pow(r, 1 / 2.4) - 0.055;
      rgb.g = g <= 0.0031308 ? 12.92 * g : 1.055 * Math.pow(g, 1 / 2.4) - 0.055;
      rgb.b = b <= 0.0031308 ? 12.92 * b : 1.055 * Math.pow(b, 1 / 2.4) - 0.055;
      
      if(truncateInvisibleColors)
      {
        rgb.r = (rgb.r <= 0) ? 0 : (rgb.r >= 1 ? 1 : Math.round(rgb.r * 255) / 255);
        rgb.g = (rgb.g <= 0) ? 0 : (rgb.g >= 1 ? 1 : Math.round(rgb.g * 255) / 255);
        rgb.b = (rgb.b <= 0) ? 0 : (rgb.b >= 1 ? 1 : Math.round(rgb.b * 255) / 255);
      }
      
      return rgb.r * 255 << 16 ^ rgb.g * 255 << 8 ^ rgb.b * 255;
    }
    
    // Performs a HSL to Hex conversion
    public static function convertHSLToHex(hsl:Object, roundColors:Boolean = false):Number
    {
      var rgb:Object = {r: 0, g: 0, b: 0},
          q:Number, 
          p:Number, 
          h:Number;

      if(hsl.s === 0)
      {
        rgb.r = hsl.l;
        rgb.g = hsl.l;
        rgb.b = hsl.l;
      }
      else
      {
        q = hsl.l < 1 / 2 ? hsl.l * (1 + hsl.s) : hsl.s + hsl.l * (1 - hsl.s);
        p = 2 * hsl.l - q;
        rgb.r = hueToRGBHelper(p, q, (hsl.h + 120) / 360);
        rgb.g = hueToRGBHelper(p, q, hsl.h / 360);
        rgb.b = hueToRGBHelper(p, q, (hsl.h - 120) / 360);
      }
      
      if(roundColors)
      {
        rgb.r = Math.round(rgb.r * 255) / 255;
        rgb.g = Math.round(rgb.g * 255) / 255;
        rgb.b = Math.round(rgb.b * 255) / 255;
      }
      
      return rgb.r * 255 << 16 ^ rgb.g * 255 << 8 ^ rgb.b * 255;
    }
    
    // Converts XYZ to RGB
    public static function convertXYZToRGB(xyz:Object, truncateInvisibleColors:Boolean = false):Object
    {
      var rgb:Object = {r: 0, g: 0, b: 0};
      var r:Number, g:Number, b:Number;
      var sRGB:Array = 
      [
       [3.2404542, -1.5371385, -0.4985314],
       [-0.9692660, 1.8760108, 0.0415560],
       [0.0556434, -0.2040259, 1.0572252]
      ];
      var transformation:DynamicMatrix = new DynamicMatrix(3, 3);
      
      var value:Number;
      for(var row:int = 0;row < sRGB.length; row++)
      {
        for(var col:int = 0;col < sRGB[row].length; col++)
        {
          value = sRGB[row][col];
          transformation.SetValue(row, col, value);
        }
      }
      
      var XYZ:DynamicMatrix = new DynamicMatrix(1, 3);
      XYZ.SetValue(0, 0, xyz.x);
      XYZ.SetValue(1, 0, xyz.y);
      XYZ.SetValue(2, 0, xyz.z);

      transformation.Multiply(XYZ, DynamicMatrix.MATRIX_ORDER_APPEND);
      
      r = transformation.GetValue(0, 0);
      g = transformation.GetValue(1, 0);
      b = transformation.GetValue(2, 0);
      
      rgb.r = r <= 0.0031308 ? 12.92 * r : 1.055 * Math.pow(r, 1 / 2.4) - 0.055;
      rgb.g = g <= 0.0031308 ? 12.92 * g : 1.055 * Math.pow(g, 1 / 2.4) - 0.055;
      rgb.b = b <= 0.0031308 ? 12.92 * b : 1.055 * Math.pow(b, 1 / 2.4) - 0.055;
      
      if(truncateInvisibleColors)
      {
        rgb.r = (rgb.r <= 0) ? 0 : (rgb.r >= 1 ? 1 : Math.round(rgb.r * 255) / 255);
        rgb.g = (rgb.g <= 0) ? 0 : (rgb.g >= 1 ? 1 : Math.round(rgb.g * 255) / 255);
        rgb.b = (rgb.b <= 0) ? 0 : (rgb.b >= 1 ? 1 : Math.round(rgb.b * 255) / 255);
      }
      
      return rgb;
    }
    
    // Converts XYZ to LAB
    public static function convertXYZToLAB(xyz:Object):Object
    {
      var lab:Object = {l: 0, a: 0, b: 0};
      var fx:Number, fy:Number, fz:Number;
      var xr:Number, yr:Number, zr:Number;
      
      xr = xyz.x / XW;
      yr = xyz.y / YW;
      zr = xyz.z / ZW;
      
      fx = xr <= E ? (K * xr + 16) / 116 : Math.pow(xr, 1 / 3);
      fy = yr <= E ? (K * yr + 16) / 116 : Math.pow(yr, 1 / 3);
      fz = zr <= E ? (K * zr + 16) / 116 : Math.pow(zr, 1 / 3);
      
      lab.l = 116 * fy - 16;
      lab.a = 500 * (fx - fy);
      lab.b = 200 * (fy - fz);
      
      return lab;
    }
    
    // Converts RGB to HSL
    public static function convertRGBToHSL(rgb:Object):Object
    {
      var hsl:Object = {h: Number.NaN, s: 0, l: 0};
      var max:Number, min:Number;
      
      max = Math.max(Math.max(rgb.r, rgb.b), rgb.g);
      min = Math.min(Math.min(rgb.r, rgb.b), rgb.g);
      
      hsl.l = (max + min) / 2;
      
      if(max != min)
      {
        hsl.s = hsl.l <= (1 / 2) ? (max - min) / (2 * hsl.l) : (max - min) / (2 - 2 * hsl.l);
      }
      
      if(max != min)
      {
        if(max == rgb.r)
        {
          hsl.h = (60 * ((rgb.g - rgb.b) / (max - min)));
          
          if(hsl.h < 0)
          {
            hsl.h += 360;
          }
        }
        else if(max == rgb.g)
        {
          hsl.h = 60 * ((rgb.b - rgb.r) / (max - min)) + 120;
        }
        else if(max == rgb.b)
        {
          hsl.h = 60 * ((rgb.r - rgb.g) / (max - min)) + 240;
        }
      }
      
      return hsl;
    }
    
    // Helper function for convertHSLToRGB
    public static function hueToRGBHelper(p:Number, q:Number, t:Number):Number
    {
      t = t < 0 ? t + 1 : t > 1 ? t - 1 : t;
      
      if(t < 1 / 6) return p + (q - p) * 6 * t;
      if(t < 1 / 2) return q;
      if(t < 2 / 3) return p + (q - p) * ((12 - 18 * t) / 3);
      return p;
    }
    
    // Converts HSL to RGB
    public static function convertHSLToRGB(hsl:Object, roundColors:Boolean = false):Object
    {
      var rgb:Object = {r: 0, g: 0, b: 0};
      var q:Number, p:Number, h:Number;

      if(hsl.s === 0)
      {
        rgb.r = hsl.l;
        rgb.g = hsl.l;
        rgb.b = hsl.l;
      }
      else
      {
        q = hsl.l < 1 / 2 ? hsl.l * (1 + hsl.s) : hsl.s + hsl.l * (1 - hsl.s);
        p = 2 * hsl.l - q;
        rgb.r = hueToRGBHelper(p, q, (hsl.h + 120) / 360);
        rgb.g = hueToRGBHelper(p, q, hsl.h / 360);
        rgb.b = hueToRGBHelper(p, q, (hsl.h - 120) / 360);
      }
      
      if(roundColors)
      {
        rgb.r = Math.round(rgb.r * 255) / 255;
        rgb.g = Math.round(rgb.g * 255) / 255;
        rgb.b = Math.round(rgb.b * 255) / 255;
      }
      
      return rgb;
    }
    
    // Converts LAB to XYZ
    public static function convertLABToXYZ(lab:Object):Object
    {
      var xyz:Object = {x: 0, y: 0, z: 0};
      var fx:Number, fy:Number, fz:Number;
      var xr:Number, yr:Number, zr:Number;
      
      fy = (lab.l + 16) / 116;
      fz = fy - (lab.b / 200);
      fx = lab.a / 500 + fy;
      
      xr = Math.pow(fx, 3) <= E ? (116 * fx - 16) / K : Math.pow(fx, 3);
      yr = lab.l > K * E ? Math.pow((lab.l + 16) / 116, 3) : lab.l / K;
      zr = Math.pow(fz, 3) <= E ? (116 * fz - 16) / K : Math.pow(fz, 3);
      
      xyz.x = xr * XW;
      xyz.y = yr * YW;
      xyz.z = zr * ZW;
      
      return xyz;
    }
    
    // Converts RGB to XYZ
    public static function convertRGBToXYZ(rgb:Object):Object
    {
      var xyz:Object = {x: 0, y: 0, z: 0};
      var r:Number, g:Number, b:Number;
      var sRGB:Array = 
      [
       [0.4124564, 0.3575761, 0.1804375],
       [0.2126729, 0.7151522, 0.0721750],
       [0.0193339, 0.1191920, 0.9503041]
      ];
      var transformation:DynamicMatrix = new DynamicMatrix(3, 3);
      
      var value:Number;
      for(var row:int = 0;row < sRGB.length; row++)
      {
        for(var col:int = 0;col < sRGB[row].length; col++)
        {
          value = sRGB[row][col];
          transformation.SetValue(row, col, value);
        }
      }
      
      r = rgb.r <= 0.04045 ? rgb.r / 12.92 : Math.pow(((rgb.r + 0.055) / 1.055), 2.4);
      g = rgb.g <= 0.04045 ? rgb.g / 12.92 : Math.pow(((rgb.g + 0.055) / 1.055), 2.4);
      b = rgb.b <= 0.04045 ? rgb.b / 12.92 : Math.pow(((rgb.b + 0.055) / 1.055), 2.4);
      
      var RGB:DynamicMatrix = new DynamicMatrix(1, 3);
      RGB.SetValue(0, 0, r);
      RGB.SetValue(1, 0, g);
      RGB.SetValue(2, 0, b);

      transformation.Multiply(RGB, DynamicMatrix.MATRIX_ORDER_APPEND);
      
      xyz.x = transformation.GetValue(0, 0);
      xyz.y = transformation.GetValue(1, 0);
      xyz.z = transformation.GetValue(2, 0);
      
      return xyz;
    }
  }
}


























