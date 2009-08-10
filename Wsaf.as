package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import gs.*;
	
	[SWF (width=640, height=480, frameRate=50)]
	public class Wsaf extends Sprite
	{
		private var time: int;
		private var totalTime: int;
		
		private var timer: int;
		
		private var difficulty: Number;
		
		public static var circles: Array;
		private var targets: Array;
		
		public var score: Score;
		
		private var audioControl: AudioControl;
		
		public var peopleLayer: Sprite;
		private var targetLayer: Sprite;
		
		private var mouseControl: MouseControl;
		
		public static function colour (id: int): int
		{
			return Circle.colour(id);
		}
		
		public static function darkColour (id: int): int
		{
			return Circle.darkColour(id);
		}
		
		public function Wsaf()
		{
			score = new Score();
			
			addChild(score);
			
			audioControl = new AudioControl();
			
			addChild(audioControl);
			
			peopleLayer = new Sprite();
			targetLayer = new Sprite();
			
			addChild(peopleLayer);
			addChild(targetLayer);
			
			mouseControl = new MouseControl();
			
			mouseControl.init();
			
			addChild(mouseControl);
			
			circles = [];
			targets = [];
			
			for (var i: int; i < 4; i++)
			{
				var target: Target = new Target(i);
				
				targets.push(target);
				
				targetLayer.addChild(target);
			}
			
			timer = 500;
			
			time = getTimer();
			
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function onEnterFrame(e:Event):void
		{
			var dt:int = getTimer() - time;
			
			while (dt >= 20) {
				time += 20;
				dt -= 20;
				
				update(20);
				draw();
			}
		}
		
		private function init (param : * = 0): void
		{
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			///stage.addEventListener(MouseEvent.MOUSE_DOWN, MouseControl.onMouseDown);
			//stage.addEventListener(MouseEvent.MOUSE_UP, MouseControl.onMouseUp);
		}
		
		private function update (dt: int): void
		{
			if (score.isGameOver) { return; }
			
			totalTime += dt;
			timer -= dt;
			
			mouseControl.update(circles);
			
			var circle: Circle;
			
			difficulty = totalTime / 100000.0 + score.combo / 2.0;
			
			//score.score = difficulty;
			
			if (timer < 0)
			{
				timer = Math.max(2500 - difficulty * 500, 500) + Math.random() * 1000;
				
				circle = new Circle();
				
				circles.push(circle);
				
				peopleLayer.addChild(circle);
			}
			
			for each (circle in circles)
			{
				circle.update(dt);
			}
			
			CollisionManager.update(circles, targets);
			
			circles = circles.filter(removeCirclesFilter);
		}
		
		private function draw (): void
		{
			mouseControl.draw();
			
			for each (var circle: Circle in circles)
			{
				circle.draw();
			}
		}
		
		private function removeCirclesFilter (c: Circle, index: int, arr: Array): Boolean
		{
			targets[int(c.x / 160)].test(c, this);
			
			if (c.dead)
			{
				// Remove from display list
				peopleLayer.removeChild(c);
				
				// And remove from array
				return false;
			}
			else
			{
				// c remains in array
				return true;
			}
		}
		
	}
}
