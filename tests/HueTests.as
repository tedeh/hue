package tests {
  import asunit.framework.TestSuite;

  public class HueTests extends TestSuite 
  {
    
    public function HueTests() 
    {
      super();
      addTest(new HueTest('testConversionRGBXYZ'));
      addTest(new HueTest('testConversionXYZLAB'));
      addTest(new HueTest('testConversionRGBHSL'));
      addTest(new HueTest('testLABConsistance'));
    }
  }
}
