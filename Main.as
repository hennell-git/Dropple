
package
{
	import flash.display.*;

	public class Main extends Sprite
	{
		public static function set screen (newScreenObj: DisplayObject): void
		{
			if (screenObj)
			{
				parentObj.removeChild(screenObj)
			}
			
			screenObj = newScreenObj;
			
			parentObj.addChild(screenObj);
		}
		
		public static function get screen (): DisplayObject
		{
			return screenObj;
		}
		
		public function Main ()
		{
			parentObj = this;
		}
		
		private static var screenObj: DisplayObject;
		
		private static var parentObj: Sprite;
		
	}
}


