package library.hue
{
  import flash.events.Event;  
  import flash.display.Sprite;  
  
  public class HueInterlacer 
  {
  	private static var currentComponentX:String;
  	private static var currentComponentY:String;
  	private static var currentComponentZ:String;
  	private static var elapsedFrames:uint = 0;
  	
  	private static var renderWidth:uint;
  	private static var renderHeight:uint;
  	private static var renderColor:Hue;
  	private static var renderSprite:Sprite;
  	private static var renderFunction:Function;
  	private static var renderPrecision:uint;
  	
  	public static function isActivePlane(s:Sprite, componentX:String, componentY:String):Boolean
  	{
  		return currentComponentX == componentX && currentComponentY == componentY && s.hasEventListener(Event.ENTER_FRAME);
  	}
  	
  	public static function activatePlane(render:Function, s:Sprite, width:uint, height:uint, color:Hue, componentX:String, componentY:String):void
  	{
  		renderWidth = width;
  		renderHeight = height;
  		renderColor = color;
  		renderSprite = s;
  		renderFunction = render;
  		renderPrecision = HuePrecision.BPP5;
  		
      currentComponentX = componentX;
  		currentComponentY = componentY;
  		
  		resetFrames();
  		
  		renderSprite.addEventListener(Event.ENTER_FRAME, frameHandler);
  	}
  	
  	public static function deactivatePlane():void
  	{
  		resetFrames();
  		currentComponentX = null;
  		currentComponentY = null;
  		renderSprite.removeEventListener(Event.ENTER_FRAME, frameHandler);
  	}
  	
  	public static function getPrecision():uint
  	{
      return renderPrecision;
    }
  	
  	public static function render():void
  	{
  		renderSprite.graphics.clear();
  		renderSprite.scaleX = 1;
      renderSprite.scaleY = 1;
  		renderFunction(renderSprite, renderWidth, renderHeight, renderColor, currentComponentX, currentComponentY);
  	}
  	
  	public static function resetFrames():void
  	{
  		elapsedFrames = 0;
  	}

    public static function frameHandler(e:Event):void
  	{
  		switch(elapsedFrames)
  		{
  			case 1:
          renderPrecision = HuePrecision.BPP7;
          render();
  			  deactivatePlane();
  			break;
  		}
  		
  		elapsedFrames++;
  	}
  }
}


















