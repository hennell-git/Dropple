package
{
	public class CollisionManager
	{
		public static function update (circles: Array): void
		{
			for (var i : int = 0; i < circles.length; i++)
			{
				var c1 : Circle = circles[i];
				
				for (var j : int = i + 1; j < circles.length; j++)
				{
					var c2 : Circle = circles[j];
					
					var dx: Number = c2.x - c1.x;
					var dy: Number = c2.y - c1.y;
					
					var dzSq: Number = dx * dx + dy * dy;
					
					var radius : Number = c1.radius + c2.radius;
					
					if (dzSq < radius * radius)
					{
						/*if ((c1 == MouseControl.dragTarget || c2 == MouseControl.dragTarget) && c1.id == c2.id)
						{
							var mergee: Circle = (c1 == MouseControl.dragTarget) ? c2 : c1;
							
							mergee.mergeTarget = MouseControl.dragTarget;
							
							TweenLite.to(mergee, 0.2, {scaleX: 0, scaleY: 0, onComplete: mergeComplete, onCompleteParams: [mergee]});
							
							MouseControl.dragTarget.vx = (MouseControl.dragTarget.vx + mergee.vx) * 0.5;
							MouseControl.dragTarget.vy = (MouseControl.dragTarget.vy + mergee.vy) * 0.5;
						}
						else*/
						{
							var dz: Number = Math.sqrt(dzSq);
							
							dx /= dz;
							dy /= dz;
							
							var u1 : Number = c1.vx * dx + c1.vy * dy;
							var u2 : Number = c2.vx * dx + c2.vy * dy;
							
							c1.vx += 0.5 * (u2 - u1) * dx;
							c1.vy += 0.5 * (u2 - u1) * dy;
							c2.vx += 0.5 * (u1 - u2) * dx;
							c2.vy += 0.5 * (u1 - u2) * dy;
							
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
	}
}
