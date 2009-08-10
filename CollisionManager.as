package
{
	import gs.*;
	
	public class CollisionManager
	{
		private static const emptyArray: Array = new Array();
		
		public static function update (circles: Array, targets: Array = null): void
		{
			if (! targets)
			{
				targets = emptyArray;
			}
			
			for (var i : int = 0; i < circles.length; i++)
			{
				var c1 : Circle = circles[i];
				
				var dx: Number;
				var dy: Number;
				
				for (var j : int = i + 1; j < circles.length; j++)
				{
					var c2 : Circle = circles[j];
					
					if (c1.mergeTarget || c2.mergeTarget) { continue; }
					
					dx = c2.x - c1.x;
					dy = c2.y - c1.y;
					
					var dzSq: Number = dx * dx + dy * dy;
					
					var radius : Number = c1.radius + c2.radius;
					
					if (dzSq < radius * radius)
					{
						if (Settings.absorb && (c1 == MouseControl.dragTarget || c2 == MouseControl.dragTarget) && c1.id == c2.id)
						{
							var src: Circle = (c1 == MouseControl.dragTarget) ? c2 : c1;
							var dest: Circle = MouseControl.dragTarget;
							
							src.mergeTarget = dest;
							
							TweenLite.to(src, 0.2, {scaleX: 0, scaleY: 0, onComplete: mergeComplete, onCompleteParams: [src]});
							
							dest.vx = (dest.vx * dest.mass + src.vx * src.mass) / (dest.mass + src.mass);
							dest.vy = (dest.vy * dest.mass + src.vy * src.mass) / (dest.mass + src.mass);
							
							dest.mass += src.mass;
							
							var scale: Number = Math.sqrt(dest.mass);
							
							TweenLite.to(dest, 0.2, {scaleX: scale, scaleY: scale, radius: scale * 20});
							
						}
						else
						{
							var dz: Number = Math.sqrt(dzSq);
							
							dx /= dz;
							dy /= dz;
							
							var u1 : Number = c1.vx * dx + c1.vy * dy;
							var u2 : Number = c2.vx * dx + c2.vy * dy;
							
							var dv: Number = 1.5 * (u1 - u2);
							
							var dvPerImpulse: Number = 1.0 / c2.mass + 1.0 / c1.mass;
							
							var impulse: Number = dv / dvPerImpulse;
							
							c1.vx -= impulse * dx / c1.mass;
							c1.vy -= impulse * dy / c1.mass;
							c2.vx += impulse * dx / c2.mass;
							c2.vy += impulse * dy / c2.mass;
							
							/*c1.vx += 0.5 * (u2 - u1) * dx;
							c1.vy += 0.5 * (u2 - u1) * dy;
							c2.vx += 0.5 * (u1 - u2) * dx;
							c2.vy += 0.5 * (u1 - u2) * dy;*/
							
							
							
							var overlap: Number = radius - dz;
							
							dx *= 0.5 * overlap;
							dy *= 0.5 * overlap;
							
							c1.x -= dx;
							c1.y -= dy;
							c2.x += dx;
							c2.y += dy;
						}
					}
				}
			}
		}
		
		private static function mergeComplete (c: Circle): void
		{
			c.dead = true;
		}
		
	}
}
