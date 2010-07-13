package tests
{
  import asunit.framework.TestCase;
 
  import library.hue.*;

  public class HueComponentTest extends TestCase 
  {
    public function HueComponentTest(testMethod:String) 
    {
     super(testMethod);
    }
    
    public function testMethodExceptions():void
    {
      assertThrows(ArgumentError, function():void {
        HueComponent.getGroupForComponent("I don't exist");
      });
      
      assertThrows(ArgumentError, function():void {
        HueComponent.getPropertyForComponent("I don't exist");
      });
    }
    
    public function testGroupComponentMethod():void
    {
      assertSame(HueComponent.getGroupForComponent(HueComponent.HSL_HUE), HueComponent.HSL);
      assertSame(HueComponent.getGroupForComponent(HueComponent.HSL_LIGHTNESS), HueComponent.HSL);
      assertSame(HueComponent.getGroupForComponent(HueComponent.HSL_SATURATION), HueComponent.HSL);
      
      assertSame(HueComponent.getGroupForComponent(HueComponent.RGB_RED), HueComponent.RGB);
      assertSame(HueComponent.getGroupForComponent(HueComponent.RGB_GREEN), HueComponent.RGB);
      assertSame(HueComponent.getGroupForComponent(HueComponent.RGB_BLUE), HueComponent.RGB);
      
      assertSame(HueComponent.getGroupForComponent(HueComponent.LAB_L), HueComponent.LAB);
      assertSame(HueComponent.getGroupForComponent(HueComponent.LAB_A), HueComponent.LAB);
      assertSame(HueComponent.getGroupForComponent(HueComponent.LAB_B), HueComponent.LAB);
      
      assertSame(HueComponent.getGroupForComponent(HueComponent.XYZ_X), HueComponent.XYZ);
      assertSame(HueComponent.getGroupForComponent(HueComponent.XYZ_Y), HueComponent.XYZ);
      assertSame(HueComponent.getGroupForComponent(HueComponent.XYZ_Z), HueComponent.XYZ);
    }
  }
}