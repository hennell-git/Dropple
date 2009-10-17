package
{
	import flash.display.*;
	
	public class Particle extends Shape
	{
		public var vy: Number;
		public var vx: Number;
		
		public var dead: Boolean = false;
		
		public function Particle(_x: Number, _y: Number, _vx: Number = 0, _vy: Number = 0)
		{
			x = _x;
			y = _y;
			
			vx = _vx;
			vy = _vy;
		}
		
		public function update (dt: int): void
		{
			x += vx * dt;
			y += vy * dt;
		}
		
	}
}
