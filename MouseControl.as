package
{
	import flash.display.*;
	import flash.events.*;
	
	public class MouseControl extends Shape
	{
		public static var highlight : Circle;
		public static var isMouseDown : Boolean;
		
		private static var _dragTarget : Circle;
		
		public static function get dragTarget (): Circle
		{
			return _dragTarget;
		}
		
		public static function set dragTarget (c: Circle): void
		{
			if (c == _dragTarget) { return; }
			
			if (_dragTarget)
			{
				_dragTarget.leftEye.scaleX = 1;
				_dragTarget.leftEye.scaleY = 1;
				_dragTarget.rightEye.scaleX = 1;
				_dragTarget.rightEye.scaleY = 1;
			}
			
			if (c)
			{
				c.leftEye.scaleX = 1.25;
				c.leftEye.scaleY = 1.25;
				c.rightEye.scaleX = 1.25;
				c.rightEye.scaleY = 1.25;
			}
			
			_dragTarget = c;
		}
		
		public function MouseControl ()
		{
			dragTarget = null;
			highlight = null;
		}
		
		public function init () : void
		{
			dragTarget = null;
			highlight = null;
		}
		
		public function update (circles: Array) : void
		{
			var mx: Number;
			var my: Number;
			
			if (dragTarget)
			{
				var massScale: Number = 1.0 / dragTarget.mass;
				
				mx = dragTarget.mouseX * dragTarget.scaleX;
				my = dragTarget.mouseY * dragTarget.scaleY;
				
				var dx : Number = mx * 0.002 * massScale - dragTarget.vx * 0.1;
				var dy : Number = my * 0.002 * massScale - dragTarget.vy * 0.1;
				
				dragTarget.vx += dx;
				dragTarget.vy += dy;
				
				highlight = dragTarget;
				
				dragTarget.touched = true;
			}
			else
			{
				var distSq : Number = Number.POSITIVE_INFINITY;
				highlight = null;
				
				for each (var c : Circle in circles)
				{
					if (! c.active || c.mergeTarget) { continue; }
					
					mx = c.mouseX * c.scaleX;
					my = c.mouseY * c.scaleY;
					
					var thisDistSq : Number = mx * mx + my * my;
					
					if (thisDistSq < distSq)
					{
						distSq = thisDistSq;
						
						if (distSq <= c.radius * c.radius * 2)
						{
							highlight = c;
						}
					}
				}
				
				if (isMouseDown)
				{
					dragTarget = highlight;
				}
			}
		}
		
		public function draw () : void
		{
			graphics.clear();
			
			if (dragTarget)
			{
				graphics.lineStyle(2, 0x000000, 0.5, true, LineScaleMode.NONE);
				graphics.moveTo(0, 0);
				graphics.lineTo(dragTarget.mouseX * dragTarget.scaleX, dragTarget.mouseY * dragTarget.scaleY);
				
				x = dragTarget.x;
				y = dragTarget.y;
			}
			else if (highlight)
			{
				graphics.lineStyle(2, 0x000000, 0.2, true, LineScaleMode.NONE);
				graphics.moveTo(0, 0);
				graphics.lineTo(highlight.mouseX * highlight.scaleX, highlight.mouseY * highlight.scaleY);
				
				x = highlight.x;
				y = highlight.y;
			}
		}
		
		public static function onMouseDown(e:MouseEvent):void
		{
			dragTarget = highlight;
			isMouseDown = true;
		}
		
		public static function onMouseUp(e:MouseEvent):void
		{
			dragTarget = null;
			isMouseDown = false;
		}
		
	}
}
