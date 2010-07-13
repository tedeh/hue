package tests 
{
  import asunit.textui.TestRunner;
  
  public class HueTestRunner extends TestRunner
  {
    public function HueTestRunner() 
    {
      start(HueTests, null, TestRunner.SHOW_TRACE);
      start(HueComponentTests, null, TestRunner.SHOW_TRACE);
    }
  }
}
