package
{
	import flash.display.*;
	
	public class Eye extends Sprite
	{
		public const RADIUS: Number = 4;
		private var _pupilSize: Number = 2;
		private var pupil: Shape;
		
		public function get pupilSize (): Number
		{
			return _pupilSize;
		}
		
		public function set pupilSize (n: Number): void
		{
			_pupilSize = n;
			
			pupil.scaleX = n;
			pupil.scaleY = n;
		}
		
		public function Eye (_x: Number, _y: Number)
		{
			x = _x;
			y = _y;
			
		 	graphics.beginFill(0xFFFFFF);
			graphics.drawCircle(0, 0, RADIUS);
			graphics.endFill();
			
			pupil = new Shape();
			
		 	pupil.graphics.beginFill(0x000000);
			pupil.graphics.drawCircle(0, 0, 1);
			pupil.graphics.endFill();
			
			pupil.scaleX = pupilSize;
			pupil.scaleY = pupilSize;
			
			addChild(pupil);
		}
		
		public function draw (): void
		{
			var dx: Number = mouseX;
			var dy: Number = mouseY;
			var dz: Number = Math.sqrt(dx*dx + dy*dy);
			
			dx *= (RADIUS - 1 - pupilSize) / dz;
			dy *= (RADIUS - 1 - pupilSize) / dz;
			
			pupil.x = dx;
			pupil.y = dy;
		}
		
	}
}
