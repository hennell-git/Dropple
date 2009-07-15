package
{
	import flash.display.*;
	
	public class Target extends Sprite
	{
		public function Target(id: int)
		{
			graphics.beginFill(Wsaf.colour(id));
			graphics.drawRect(0, 0, 640/4, 50);
			graphics.endFill();
			
			x = id * width;
			y = 480 - height;
		}
	}
}

