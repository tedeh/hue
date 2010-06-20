/*
 * HueSpectrum
 * A collection of methods for drawing a spectrum on a Sprite
 * 
 * License:
 * http://creativecommons.org/licenses/by-sa/3.0/
 * 
 * Created by Tedde Lundgren
 * 
 */
package library.hue
{
    import flash.display.GradientType;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.geom.Matrix;  

    public final class HueSpectrum 
    {
        // Returns the line function for the specified component
        public static function getLineFunctionForComponent(component:String):Function
        {
            switch(component)
            {
                case HueComponent.HSL_HUE:
                    return hueLine;
                case HueComponent.HSL_SATURATION:
                    return saturationLine;
                case HueComponent.HSL_LIGHTNESS:
                    return lightnessLine;
                case HueComponent.RGB_RED:
                    return redLine;
                case HueComponent.RGB_GREEN:
                    return greenLine;
                case HueComponent.RGB_BLUE:
                    return blueLine;
                case HueComponent.LAB_L:
                    return lablLine;
                case HueComponent.LAB_A:
                    return labaLine;
                case HueComponent.LAB_B:
                    return labbLine;
            }
        }

        // Returns the plane function for the specified component
        public static function getPlaneFunctionForComponent(component:String):Function
        {
            switch(component)
            {
                case HueComponent.HSL_HUE:
                    return huePlane;
                case HueComponent.HSL_SATURATION:
                    return saturationPlane;
                case HueComponent.HSL_LIGHTNESS:
                    return lightnessPlane;
                case HueComponent.RGB_RED:
                    return redPlane;
                case HueComponent.RGB_GREEN:
                    return greenPlane;
                case HueComponent.RGB_BLUE:
                    return bluePlane;
                case HueComponent.LAB_L:
                    return lablPlane;
                case HueComponent.LAB_A:
                    return labaPlane;
                case HueComponent.LAB_B:
                    return labbPlane;
            }
        }

        // Returns the components (and their axis) used for the spectrum plane methods
        public static function getPlaneComponentsForComponent(component:String):Object
        {
            switch(component)
            {
                case HueComponent.HSL_HUE:
                    return {x: HueComponent.HSL_LIGHTNESS, y: HueComponent.HSL_SATURATION};
                case HueComponent.HSL_SATURATION:
                    return {x: HueComponent.HSL_HUE, y: HueComponent.HSL_LIGHTNESS};
                case HueComponent.HSL_LIGHTNESS:
                    return {x: HueComponent.HSL_HUE, y: HueComponent.HSL_SATURATION};
                case HueComponent.RGB_RED:
                    return {x: HueComponent.RGB_BLUE, y: HueComponent.RGB_GREEN};
                case HueComponent.RGB_GREEN:
                    return {x: HueComponent.RGB_BLUE, y: HueComponent.RGB_RED};
                case HueComponent.RGB_BLUE:
                    return {x: HueComponent.RGB_RED, y: HueComponent.RGB_GREEN};
                case HueComponent.LAB_L:
                    return {x: HueComponent.LAB_A, y: HueComponent.LAB_B};
                case HueComponent.LAB_A:
                    return {x: HueComponent.LAB_B, y: HueComponent.LAB_L};
                case HueComponent.LAB_B:
                    return {x: HueComponent.LAB_A, y: HueComponent.LAB_L};
            }
        }

        // Draws a LAB plane with B as Y and A as X
        public static function lablPlane(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            var components:Object = getPlaneComponentsForComponent(HueComponent.LAB_L);
            labPlane(s, width, height, color, components.x, components.y);
        }

        // Draws a LAB plane with L as Y and B as X
        public static function labaPlane(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            var components:Object = getPlaneComponentsForComponent(HueComponent.LAB_A);
            labPlane(s, width, height, color, components.x, components.y);
        }

        // Draws a LAB plane with L as Y and A as X
        public static function labbPlane(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            var components:Object = getPlaneComponentsForComponent(HueComponent.LAB_B);
            labPlane(s, width, height, color, components.x, components.y);
        }

        private static function labPlane(s:Sprite, width:uint, height:uint, color:Hue, componentX:String, componentY:String):void
        {
            var xRange:Object = HueScale.getRangeForScale(componentX, HueScale.REAL),
                yRange:Object = HueScale.getRangeForScale(componentY, HueScale.REAL),
                xProperty:String = HueComponent.getPropertyForComponent(componentX),
                yProperty:String = HueComponent.getPropertyForComponent(componentY),
                precision:uint = color.options.precision,
                lab:Object = color.getGroupCopy(HueComponent.LAB),
                x:uint, 
                y:uint, 
                hex:Number, 
                g:Graphics = s.graphics,
                stepX:Number,
                stepY:Number,
                xFactor:Number,
                yFactor:Number,
                interlacer:HueInterlacer;
    
            if(precision == HuePrecision.BPP8)
            {
                if(HueInterlacer.isActivePlane(s, componentX, componentY))
                {
                    precision = HueInterlacer.getPrecision();
                    HueInterlacer.resetFrames();
                }
                else
                {
                    precision = HuePrecision.BPP5;
                    HueInterlacer.activatePlane(labPlane, s, width, height, color, componentX, componentY);
                }
            }
    
            xFactor = width / precision,
            yFactor = height / precision;
    
            for(stepX = 0; stepX < precision; stepX++)
            {
                x = Math.floor(xFactor * stepX);
                lab[xProperty] = HueScale.change(stepX, 0, precision - 1, xRange.min, xRange.max);
    
                for(stepY = 0; stepY < precision; stepY++)
                {
                    y = Math.floor(yFactor * stepY);
                    lab[yProperty] = HueScale.change(stepY, 0, precision - 1, yRange.max, yRange.min);
    
                    hex = Hue.convertLABToHex(lab, true);
    
                    g.beginFill(hex);
                    g.drawRect(x, y, Math.ceil(xFactor), Math.ceil(yFactor));
                    g.endFill();
                }
            }
        }

        private static function labLine(s:Sprite, width:uint, height:uint, color:Hue, component:String):void
        {
            var lab:Object = color.getGroupCopy(HueComponent.LAB),
                range:Object = HueScale.getRangeForScale(component, HueScale.REAL),
                property:String = HueComponent.getPropertyForComponent(component),
                g:Graphics = s.graphics,
                precision:uint = color.options.precision,
                x:uint,
                y:uint,
                hex:Number,
                scaleFactor:Number;
    
            scaleFactor = width / precision;
    
            if(precision == HuePrecision.BPP8)
            {
                for(x = 0; x < precision; x++)
                {
                    lab[property] = HueScale.change(x, 0, precision - 1, range.min, range.max);
                    lab = HuePrecision.changeGroup(HueComponent.LAB, lab, precision);
                    hex = Hue.convertLABToHex(lab, true);
    
                    g.beginFill(hex);
                    g.drawRect(x, 0, 1, height);
                    g.endFill();
                }
    
                s.scaleX = scaleFactor;
            }
            else
            {
                var step:Number,
                    stepWidth:Number = width / precision;
    
                for(step = 0; step < precision; step++)
                {
                    x = Math.floor((stepWidth) * step);
                    lab[property] = HueScale.change(step, 0, precision - 1, range.min, range.max);
                    hex = Hue.convertLABToHex(lab, true);
        
                    g.beginFill(hex);
                    g.drawRect(x, 0, Math.ceil(stepWidth), height);
                    g.endFill();
                }
            }
        }

        // Draws a LAB line with L
        public static function lablLine(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            labLine(s, width, height, color, HueComponent.LAB_L);
        }

        // Draws a LAB line with A
        public static function labaLine(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            labLine(s, width, height, color, HueComponent.LAB_A);
        }

        // Draws a LAB line with B
        public static function labbLine(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            labLine(s, width, height, color, HueComponent.LAB_B);
        }

        private static function rgbPlane(s:Sprite, width:uint, height:uint, color:Hue, componentX:String, componentY:String):void
        {
            var precision:uint = color.options.precision,
                g:Graphics = s.graphics,
                rgbRange:Object = HueScale.getRangeForScale(HueComponent.RGB, HueScale.REAL),
                propertyX:String = HueComponent.getPropertyForComponent(componentX),
                propertyY:String = HueComponent.getPropertyForComponent(componentY);

            if(precision == HuePrecision.BPP8)
            {
                var rgbFrom:Object,
                    rgbTo:Object,
                    m:Matrix = new Matrix,
                    i:uint = 0,
                    hexFrom:Number,
                    hexTo:Number;
        
                rgbFrom = color.getGroupCopy(HueComponent.RGB);
                rgbTo = Hue.copyObject(rgbFrom);
        
                m.createGradientBox(width, height, Math.PI / 2);
        
                for(i = 0; i < width; i++)
                {
                    rgbFrom[propertyX] = HueScale.change(i, 0, width - 1, rgbRange.min, rgbRange.max);
                    rgbFrom[propertyY] = rgbRange.max;
        
                    rgbTo[propertyX] = rgbFrom[propertyX];
                    rgbTo[propertyY] = rgbRange.min;
        
                    hexFrom = Hue.convertRGBToHex(rgbFrom);
                    hexTo = Hue.convertRGBToHex(rgbTo);
        
                    g.beginGradientFill(GradientType.LINEAR, [hexFrom, hexTo], [1, 1], [0, 255], m);
                    g.drawRect(i, 0, 1, height);
                    g.endFill();
                }
            }
            else
            {
                var rgb:Object = color.getGroupCopy(HueComponent.RGB),
                    x:uint,
                    y:uint,
                    hex:Number,
                    stepX:Number,
                    stepY:Number,
                    xFactor:Number = width / precision,
                    yFactor:Number = height / precision;
        
                for(stepX = 0; stepX < precision; stepX++)
                {
                    x = Math.floor(xFactor * stepX);
                    rgb[propertyX] = HueScale.change(stepX, 0, precision - 1, rgbRange.min, rgbRange.max);
        
                    for(stepY = 0; stepY < precision; stepY++)
                    {
                        y = Math.floor(yFactor * stepY);
                        rgb[propertyY] = HueScale.change(stepY, 0, precision - 1, rgbRange.max, rgbRange.min);
        
                        hex = Hue.convertRGBToHex(rgb);
                        g.beginFill(hex);
                        g.drawRect(x, y, Math.ceil(xFactor), Math.ceil(yFactor));
                        g.endFill();
                    }
                }
            }
        }

        // Draws an RGB plane with B as X and G as Y
        public static function redPlane(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            var components:Object = getPlaneComponentsForComponent(HueComponent.RGB_RED);
            rgbPlane(s, width, height, color, components.x, components.y);
        }

        // Draws an RGB plane with B as X and R as Y
        public static function greenPlane(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            var components:Object = getPlaneComponentsForComponent(HueComponent.RGB_GREEN);
            rgbPlane(s, width, height, color, components.x, components.y);
        }

        // Draws an RGB plane with R as X and G as Y
        public static function bluePlane(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            var components:Object = getPlaneComponentsForComponent(HueComponent.RGB_BLUE);
            rgbPlane(s, width, height, color, components.x, components.y);
        }


        private static function rgbLine(s:Sprite, width:uint, height:uint, color:Hue, component:String):void
        {
            var precision:uint = color.options.precision,
                rgb:Object = color.getGroupCopy(HueComponent.RGB),
                hex:Number,
                g:Graphics = s.graphics,
                rgbRange:Object = HueScale.getRangeForScale(HueComponent.RGB, HueScale.REAL),
                property:String = HueComponent.getPropertyForComponent(component);

            if(precision == HuePrecision.BPP8)
            {
                var gradientFrom:Number, 
                    gradientTo:Number,
                    m:Matrix = new Matrix;
        
                m.createGradientBox(width, height);
        
                rgb[property] = rgbRange.min;
                gradientFrom = Hue.convertRGBToHex(rgb);
        
                rgb[property] = rgbRange.max;
                gradientTo = Hue.convertRGBToHex(rgb);
        
                g.beginGradientFill(GradientType.LINEAR, [gradientFrom, gradientTo], [1, 1], [0, 255], m);
                g.drawRect(0, 0, width, height);
                g.endFill();
            }
            else
            {
                var step:Number, 
                    stepSize:Number = 1, 
                    stepScale:Number = width / precision, 
                    x:Number;
        
                for(step = 0; step < precision; step += stepSize)
                {
                    x = Math.floor((stepScale) * step);
                    rgb[property] = HueScale.change(step, 0, precision - 1, rgbRange.min, rgbRange.max);
                    hex = Hue.convertRGBToHex(rgb);
                    g.beginFill(hex);
                    g.drawRect(x, 0, Math.ceil(stepScale), height);
                    g.endFill();
                }
            }
        }

        // Draws a RGB line with R
        public static function redLine(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            rgbLine(s, width, height, color, HueComponent.RGB_RED);
        }

        // Draws a RGB line with G
        public static function greenLine(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            rgbLine(s, width, height, color, HueComponent.RGB_GREEN);
        }

        // Draws a RGB line with B
        public static function blueLine(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            rgbLine(s, width, height, color, HueComponent.RGB_BLUE);
        }

        private static function hslPlane(s:Sprite, width:uint, height:uint, color:Hue, xComponent:String, yComponent:String):void
        {
            var precision:uint = color.options.precision,
                hsl:Object = color.getGroupCopy(HueComponent.HSL),
                g:Graphics = s.graphics,
                xRange:Object = HueScale.getRangeForScale(xComponent, HueScale.REAL),
                yRange:Object = HueScale.getRangeForScale(yComponent, HueScale.REAL),
                xProperty:String = HueComponent.getPropertyForComponent(xComponent),
                yProperty:String = HueComponent.getPropertyForComponent(yComponent),
                x:uint,
                y:uint;

            if(precision == HuePrecision.BPP8)
            {
                var hslFrom:Object,
                    hslTo:Object,
                    m:Matrix = new Matrix,
                    hexFrom:Number, 
                    hexTo:Number;
    
                hslFrom = hsl;
                hslTo = Hue.copyObject(hslFrom);
        
                m.createGradientBox(width, height, Math.PI / 2);
        
                hslFrom[yProperty] = yRange.max;
                hslTo[yProperty] = yRange.min;
        
                for(x = 0; x < width; x++)
                {
                    hslFrom[xProperty] = HueScale.change(x, 0, width - 1, xRange.min, xRange.max);
                    hslTo[xProperty] = hslFrom[xProperty];
        
                    hexFrom = Hue.convertHSLToHex(hslFrom, true);
                    hexTo = Hue.convertHSLToHex(hslTo, true);
        
                    g.beginGradientFill(GradientType.LINEAR, [hexFrom, hexTo], [1, 1], [0, 255], m);
                    g.drawRect(x, 0, 1, height);
                    g.endFill();
                }
            }
            else
            {
                var hex:Number,
                    stepX:Number,
                    stepY:Number,
                    xFactor:Number = width / precision,
                    yFactor:Number = height / precision;
    
                for(stepX = 0; stepX < precision; stepX++)
                {
                    hsl[xProperty] = HueScale.change(stepX, 0, precision - 1, xRange.min, xRange.max);
                    x = Math.floor(xFactor * stepX);
        
                    for(stepY = 0; stepY < precision; stepY++)
                    {
                        hsl[yProperty] = HueScale.change(stepY, 0, precision - 1, yRange.max, yRange.min);
                        y = Math.floor(yFactor * stepY);
        
                        hsl = HuePrecision.changeGroup(HueComponent.HSL, hsl, precision);
                        hex = Hue.convertHSLToHex(hsl, true);
        
                        g.beginFill(hex);
                        g.drawRect(x, y, Math.ceil(xFactor), Math.ceil(yFactor));
                        g.endFill();
                    }
                }
            }
        }

        // Draws an HSL plane with L as Y and H as X
        public static function saturationPlane(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            var components:Object = getPlaneComponentsForComponent(HueComponent.HSL_SATURATION),
                precision:uint = color.options.precision,
                hsl:Object = color.getGroupCopy(HueComponent.HSL),
                g:Graphics = s.graphics,
                hRange:Object = HueScale.getRangeForScale(components.x, HueScale.REAL),
                lRange:Object = HueScale.getRangeForScale(components.y, HueScale.REAL);
    
            if(precision == HuePrecision.BPP8)
            {    
                var hslFrom:Object,
                    hslMiddle:Object,
                    hslTo:Object,
                    m:Matrix = new Matrix,
                    i:uint,
                    hexFrom:Number, 
                    hexMiddle:Number, 
                    hexTo:Number;
        
                hslFrom = hsl;
                hslMiddle = Hue.copyObject(hslFrom);
                hslTo = Hue.copyObject(hslFrom);
        
                m.createGradientBox(width, height, Math.PI / 2);
        
                hslFrom.l = lRange.max;
                hslMiddle.l = lRange.max / 2;
                hslTo.l = lRange.min;
        
                for(i = 0; i < width; i++)
                {
                    hslFrom.h = HueScale.change(i, 0, width - 1, hRange.min, hRange.max);
                    hslTo.h = hslMiddle.h = hslFrom.h;
        
                    hexFrom = Hue.convertHSLToHex(hslFrom, true);
                    hexMiddle = Hue.convertHSLToHex(hslMiddle, true);
                    hexTo = Hue.convertHSLToHex(hslTo, true);
        
                    g.beginGradientFill(GradientType.LINEAR, [hexFrom, hexMiddle, hexTo], [1, 1, 1], [0, 128, 255], m);
                    g.drawRect(i, 0, 1, height);
                    g.endFill();
                }
            }
            else
            {
                hslPlane(s, width, height, color, components.x, components.y);
            }
        }

        // Draws an HSL plane with H as X and S as Y
        public static function lightnessPlane(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            var components:Object = getPlaneComponentsForComponent(HueComponent.HSL_LIGHTNESS);
            hslPlane(s, width, height, color, components.x, components.y);
        }

        // Draws an HSL plane with L as X and S as Y
        public static function huePlane(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            var components:Object = getPlaneComponentsForComponent(HueComponent.HSL_HUE);
            hslPlane(s, width, height, color, components.x, components.y);
        }

        private static function hslPrecisionLine(s:Sprite, width:uint, height:uint, color:Hue, component:String):void
        {
            var precision:uint = color.options.precision;  
    
            if(precision !== HuePrecision.BPP8)
            {
                var step:uint,
                    hex:Number,
                    steps:Number,
                    stepWidth:Number,
                    range:Object = HueScale.getRangeForScale(component, HueScale.REAL),
                    property:String = HueComponent.getPropertyForComponent(component),
                    g:Graphics = s.graphics,
                    hsl:Object;
        
                if(component == HueComponent.HSL_HUE)
                {
                    hsl = {l: 0.5, s: 1, h: 0};
                }
                else
                {
                    hsl = color.getGroupCopy(HueComponent.HSL);
                }
        
                steps = precision;
                stepWidth = width / steps;
        
                for(step = 0; step < steps; step++)
                {
                    hsl[property] = HueScale.change(step, 0, steps - 1, range.min, range.max);
                    hsl = HuePrecision.changeGroup(HueComponent.HSL, hsl, precision);
                    hex = Hue.convertHSLToHex(hsl, true);
        
                    g.beginFill(hex);
                    g.drawRect(Math.floor(step * stepWidth), 0, Math.ceil(stepWidth), height);
                    g.endFill();
                }
            }
        }

        // Draws a HSL line with H
        public static function hueLine(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            var precision:uint = color.options.precision;
    
            if(precision == HuePrecision.BPP8)
            {
                var i:uint,
                    hex:Number, 
                    g:Graphics = s.graphics,
                    hsl:Object = {l: 0.5, s: 1, h: 0},
                    hRange:Object = HueScale.getRangeForScale(HueComponent.HSL_HUE, HueScale.REAL);
        
                for(i = 0; i < width; i++)
                {
                    hsl.h = HueScale.change(i, 0, width - 1, hRange.min, hRange.max);
                    hsl = HuePrecision.changeGroup(HueComponent.HSL, hsl, precision);
                    hex = Hue.convertHSLToHex(hsl, true);
                    g.beginFill(hex);
                    g.drawRect(i, 0, 1, height);
                    g.endFill();
                }
            }
            else
            {
                hslPrecisionLine(s, width, height, color, HueComponent.HSL_HUE);
                return;
            }
        }

        // Draws a HSL line with S
        public static function saturationLine(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            var precision:uint = color.options.precision;
    
            if(precision == HuePrecision.BPP8)
            {
                var gradientFrom:Number, 
                    gradientTo:Number,
                    m:Matrix = new Matrix,
                    sRange:Object = HueScale.getRangeForScale(HueComponent.HSL_SATURATION, HueScale.REAL),
                    g:Graphics = s.graphics,
                    hsl:Object = color.getGroupCopy(HueComponent.HSL);
        
                hsl.s = sRange.min;
                gradientFrom = Hue.convertHSLToHex(hsl, true);
        
                hsl.s = sRange.max;
                gradientTo = Hue.convertHSLToHex(hsl, true);
        
                m.createGradientBox(width, height);
        
                g.beginGradientFill(GradientType.LINEAR, [gradientFrom, gradientTo], [1, 1], [0, 255], m);
                g.drawRect(0, 0, width, height);
                g.endFill();
            }
            else
            {
                hslPrecisionLine(s, width, height, color, HueComponent.HSL_SATURATION);
            }
        }

        // Draws a HSL line with L
        public static function lightnessLine(s:Sprite, width:uint, height:uint, color:Hue):void
        {
            var precision:uint = color.options.precision;

            if(precision == HuePrecision.BPP8)
            {
                var gradientFrom:Number,
                    gradientMiddle:Number,
                    gradientTo:Number,
                    m:Matrix = new Matrix,
                    lRange:Object = HueScale.getRangeForScale(HueComponent.HSL_LIGHTNESS, HueScale.REAL),
                    g:Graphics = s.graphics,
                    hsl:Object = color.getGroupCopy(HueComponent.HSL);
        
                hsl.l = lRange.min;
                gradientFrom = Hue.convertHSLToHex(hsl, true);
        
                hsl.l = lRange.max / 2;
                gradientMiddle = Hue.convertHSLToHex(hsl, true);
        
                hsl.l = lRange.max;
                gradientTo = Hue.convertHSLToHex(hsl, true);
        
                m.createGradientBox(width, height);
        
                g.beginGradientFill(GradientType.LINEAR, [gradientFrom, gradientMiddle, gradientTo], [1, 1, 1], [0, 128, 255], m);
                g.drawRect(0, 0, width, height);
                g.endFill();
            }
            else
            {
                hslPrecisionLine(s, width, height, color, HueComponent.HSL_LIGHTNESS);
                return;
            }
        }
    }
}




















