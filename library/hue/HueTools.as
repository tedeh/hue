package library.hue
{
    import flash.utils.ByteArray;
    
    public final class HueTools
    {
        // Copies passed object
        public static function copyObject(o:Object):Object
        {
            var buffer:ByteArray = new ByteArray;
            buffer.writeObject(o);
            buffer.position = 0;
            return buffer.readObject();
        }
        
        // Linearly changes the value x, which is in the a1 and b1 interval, to be in the a2 and b2 interval
        public static function reScale(x:Number, a1:Number, b1:Number, a2:Number = 0, b2:Number = 1):Number
        {
            return (x * (a2 - b2) + a1 * b2 - a2 * b1) / (a1 - b1);
        }
    }
}