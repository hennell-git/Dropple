package
{
	import flash.display.*;
	
	public class Circle extends Sprite
	{
		public var radius: Number = 20;
		
		public var vy: Number;
		public var vx: Number;
		public var id: int;
		
		public var dead: Boolean;
		
		public var mass: Number = 1;
		
		public var touched: Boolean = false;
		
		public var mergeTarget: Circle = null;
		
		public var leftEye: Eye;
		public var rightEye: Eye;
		
		public function Circle()
		{
			x = radius + Math.random() * (480 - 2 * radius);
			y = -radius;
			
			id = (Math.random() * 4);
			
			if (x > id * 160) x += 160;
			
			vx = 0;
			vy = 0.05 + 0.05 * Math.random();
			
		 	graphics.beginFill(colour(id));
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
			
			graphics.lineStyle(4, 0x000000);
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
					return 0x0000FF;
				case 3:
					return 0xFFFF00;
				default:
					return 0x000000;
			}
		}
		
		public function update (dt: int): void
		{
			if (mergeTarget) { return; }
			
			x += vx * dt;
			y += vy * dt;
			
			if (y - radius < 0)
			{
				if (vy < 0)
				{
					y = Math.min(y - vy * dt, radius);
					vy = Math.max(-0.5*vy, vy);
				}
			}
			/*else if (y + radius > 480)
			{
				y = 480 - radius
				vy = Math.min(-0.5*vy, 0);
			}*/
			
			if (vy < 0.05)
			{
				vy += 0.0001 * dt;
			}
			
			if (x - radius < 0)
			{
				x = radius;
				vx *= -0.5;
			}
			else if (x + radius > 640)
			{
				x = 640 - radius;
				vx *= -0.5;
			}
		}
		
		public function draw (): void
		{
			leftEye.draw();
			rightEye.draw();
		}
		
	}
}
