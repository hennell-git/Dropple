
package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import gs.*;

	[SWF (width=640, height=480, frameRate=50)]

	public class Preloader extends Sprite
	{
		private var preloader : Sprite;
		
		private var circlesLayer : Sprite;
		
		public var circles: Array;
		
		private var bigCircle: Circle;
		
		private var text: MyTextField;
		
		private var mouseControl: MouseControl;
		
		private var time: int;
		
		[Embed(source="images/bg.jpg")]
		public static var bgSrc:Class;
		
		public function Preloader()
		{
			addChild(new bgSrc());
			
			addChild(new Main());
			
			preloader = new Sprite();
			
			circles = [];
			
			circlesLayer = new Sprite();
			
			bigCircle = new Circle();
			
			bigCircle.x = 320;
			bigCircle.y = 240;
			
			circlesLayer.addChild(bigCircle);
			
			text = new MyTextField(0, 0, "0%", "center", 13);
			
			text.y = -text.height * 0.33;
			
			if (bigCircle.id == 2)
			{
				text.textColor = 0xFFFFFF;
			}
			
			bigCircle.addChild(text);
			
			preloader.addChild(circlesLayer);
			
			mouseControl = new MouseControl();
			
			mouseControl.init();
			
			preloader.addChild(mouseControl);
			
			Main.screen = preloader;
			
			time = getTimer();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, MouseControl.onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, MouseControl.onMouseUp);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			preloader.alpha = 0;
			
			TweenLite.to(preloader, 1.0, {alpha: 1});
		}
		
		private function onEnterFrame (e:Event): void
		{
			var dt:int = getTimer() - time;
			
			while (dt >= 20) {
				time += 20;
				dt -= 20;
				
				update();
			}
			
			mouseControl.draw();
			
			for each (var circle: Circle in circles)
			{
				circle.draw();
			}
			
			bigCircle.draw();
		}
		
		//private var p: Number = 0;
		
		private function update(): void
		{
			var p:Number = (this.loaderInfo.bytesLoaded / this.loaderInfo.bytesTotal);
			
			//p += 0.005;
			
			var scale: Number = p * 8 + 1.5;
			
			bigCircle.radius = 20 * scale;
			bigCircle.scaleX = scale;
			bigCircle.scaleY = scale;
			
			text.text = int(100 * p) + "%";
			
			if (Math.random() < 0.1)
			{
				var c: Circle = new Circle();
				
				c.vy *= 5;
				
				circles.push(c);
				
				circlesLayer.addChild(c);
			}
			
			if (p >= 1 && preloader)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				startup();
				preloader = null;
			}
			
			mouseControl.update(circles);
			
			for each (var circle: Circle in circles)
			{
				circle.update(20);
			}
			
			CollisionManager.update(circles);
			
			for each (c in circles)
			{
				var dx: Number = bigCircle.x - c.x;
				var dy: Number = bigCircle.y - c.y;
				
				var dzSq: Number = dx * dx + dy * dy;
				
				var radius : Number = c.radius + bigCircle.radius;
				
				if (dzSq < radius * radius)
				{
					var dz: Number = Math.sqrt(dzSq);
					
					dx /= dz;
					dy /= dz;
					
					var overlap: Number = radius - dz;
					
					c.x -= dx * overlap;
					c.y -= dy * overlap;
					
					var speed: Number = c.vx * dx + c.vy * dy;
					
					speed = Math.max(speed, 0);
					
					c.vx -= 1.5 * dx * speed;
					c.vy -= 1.5 * dy * speed;
				}
			}
			
			circles = circles.filter(removeCirclesFilter);
		}

		private function removeCirclesFilter (c: Circle, index: int, arr: Array): Boolean
		{
			if (c.y > G.H + c.radius)
			{
				if (c == MouseControl.dragTarget)
				{
					MouseControl.dragTarget = null;
				}
				
				circlesLayer.removeChild(c);
				
				// And remove from array
				return false;
			}
			else
			{
				// c remains in array
				return true;
			}
		}
		
		private function startup():void
		{
			var mainClass:Class = getDefinitionByName("MainMenu") as Class;
			
			var mainObj: DisplayObject = new mainClass() as DisplayObject;
			
			Main.screen = mainObj;
		}
	}

}


