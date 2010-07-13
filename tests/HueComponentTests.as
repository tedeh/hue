package tests {
  import asunit.framework.TestSuite;

  public class HueComponentTests extends TestSuite 
  {
    public function HueComponentTests() 
    {
      super();
      addTest(new HueComponentTest('testMethodExceptions'));
      addTest(new HueComponentTest('testGroupComponentMethod'));
    }
  }
}
