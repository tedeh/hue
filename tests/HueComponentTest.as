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
     
   }
 }
 
}