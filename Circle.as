package
{
	import flash.display.*;
	
	public class Circle extends Sprite
	{
		public var radius: Number = 20;
		
		public var oldX: Number;
		public var oldY: Number;
		
		public var vy: Number;
		public var vx: Number;
		public var id: int;
		
		public var dead: Boolean;
		
		public var mass: Number = 1;
		
		public var touched: Boolean = false;
		public var active: Boolean = true;
		
		public var mergeTarget: Circle = null;
		
		public var leftEye: Eye;
		public var rightEye: Eye;
		
		public function Circle()
		{
			x = radius + Math.random() * (G.W*0.75 - 2 * radius);
			y = -radius;
			
			id = nextRandomColour();
			
			if (x > id * G.W/4) x += G.W/4;
			
			vx = 0;
			vy = 0.05 + 0.05 * Math.random();
			
		 	graphics.beginFill(colour(id));
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
			
			graphics.lineStyle(4, darkColour(id));
			graphics.drawCircle(0, 0, radius - 2);
			
			leftEye = new Eye(-7, -7);
			rightEye = new Eye(7, -7);
			
			addChild(leftEye);
			addChild(rightEye);
		}
		
		public static function colour (id: int): int
		{
			switch (id) {
				case 0:
					return 0xFF0000;
				case 1:
					return 0x00FF00;
				case 2:
					return 0x0080FF;
				case 3:
					return 0xFFFF00;
				default:
					return 0x000000;
			}
		}
		
		public static function darkColour (id: int): int
		{
			return 0x000000;
			
			switch (id) {
				case 0:
					return 0x800000;
				case 1:
					return 0x008000;
				case 2:
					return 0x0000FF;
				case 3:
					return 0x808000;
				default:
					return 0x000000;
			}
		}
		
		public function update (dt: int): void
		{
			if (mergeTarget) { return; }
			
			oldX = x;
			oldY = y;
			
			if (y - radius < 0)
			{
				if (vy < 0)
				{
					y = Math.min(y - vy * dt, radius);
					vy = Math.max(-0.5*vy, vy);
				}
			}
			/*else if (y + radius > G.H)
			{
				y = G.H - radius
				vy = Math.min(-0.5*vy, 0);
			}*/
			
			if (vy < 0.05)
			{
				vy += 0.0001 * dt;
			}
			
			x += vx * dt;
			y += vy * dt;
			
			if (x - radius < 0)
			{
				x = radius;
				vx *= -0.5;
			}
			else if (x + radius > G.W)
			{
				x = G.W - radius;
				vx *= -0.5;
			}
		}
		
		public function draw (): void
		{
			leftEye.draw();
			rightEye.draw();
		}
		
		private static var colourQueue: Array = new Array();
		
		private static function nextRandomColour (): int
		{
			if (colourQueue.length == 0) {
				// shuffle from http://flassari.is/2009/04/as3-array-shuffle/
				
				var arr2: Array = [0, 0, 1, 1, 2, 2, 3, 3];
				while (arr2.length > 0) {
					colourQueue.push(arr2.splice(Math.round(Math.random() * (arr2.length - 1)), 1)[0]);
				}
			}
			
			return colourQueue.pop();
		}
		
	}
}
